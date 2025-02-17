(*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *)

type module_ref = string

type 'a resolve_require = module_ref -> 'a Parsing_heaps.resolved_module'

type 'a check_file =
  File_key.t ->
  'a resolve_require ->
  (Loc.t, Loc.t) Flow_ast.Program.t ->
  File_sig.t ->
  Docblock.t ->
  ALoc.table Lazy.t ->
  GetDefUtils.def_info ->
  Context.t
  * (ALoc.t, ALoc.t * Type.t) Flow_ast.Program.t
  * (FindRefsTypes.single_ref list, string) result

module type READER = sig
  type provider

  type typed_parse

  type dependency

  val read_dependency : dependency -> Modulename.t

  val get_provider : dependency -> provider option

  val get_file_key : provider -> File_key.t

  val get_typed_parse : provider -> typed_parse option

  val get_leader_key : typed_parse -> File_key.t

  val get_aloc_table : typed_parse -> ALoc.table

  val get_docblock : typed_parse -> Docblock.t

  val get_type_sig_buf : typed_parse -> Type_sig_bin.buf

  val get_resolved_modules : typed_parse -> dependency Parsing_heaps.resolved_module' SMap.t

  val loc_of_aloc : ALoc.t -> Loc.t
end

val mk_heap_reader :
  Abstract_state_reader.t -> (module READER with type dependency = Parsing_heaps.dependency_addr)

val mk_check_file :
  (module READER with type dependency = 'a) ->
  options:Options.t ->
  master_cx:Context.master_context ->
  cache:Check_cache.t ->
  unit ->
  'a check_file
