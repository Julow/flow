(*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *)

type t =
  | Return
  | Throw
  | Break of string option
  | Continue of string option

type payload =
  | Expr of ALoc.t * (ALoc.t, ALoc.t * Type.t) Flow_ast.Expression.t
  | Stmt of (ALoc.t, ALoc.t * Type.t) Flow_ast.Statement.t

val throw_stmt_control_flow_exception : (ALoc.t, ALoc.t * Type.t) Flow_ast.Statement.t -> t -> 'a

val throw_expr_control_flow_exception :
  ALoc.t -> (ALoc.t, ALoc.t * Type.t) Flow_ast.Expression.t -> t -> 'a

val check_stmt_control_flow_exception :
  (ALoc.t, ALoc.t * Type.t) Flow_ast.Statement.t * t option ->
  (ALoc.t, ALoc.t * Type.t) Flow_ast.Statement.t

val catch_stmt_control_flow_exception :
  (unit -> (ALoc.t, ALoc.t * Type.t) Flow_ast.Statement.t) ->
  (ALoc.t, ALoc.t * Type.t) Flow_ast.Statement.t * t option

val catch_expr_control_flow_exception :
  (unit -> (ALoc.t, ALoc.t * Type.t) Flow_ast.Expression.t) ->
  (ALoc.t, ALoc.t * Type.t) Flow_ast.Expression.t * t option

val ignore_break_to_label : string option -> 'a * t option -> 'a * t option

val ignore_break_or_continue_to_label : string option -> 'a * t option -> 'a * t option

val try_with_abnormal_exn : f:(unit -> 'a) -> on_abnormal_exn:(payload * t -> 'a) -> unit -> 'a
