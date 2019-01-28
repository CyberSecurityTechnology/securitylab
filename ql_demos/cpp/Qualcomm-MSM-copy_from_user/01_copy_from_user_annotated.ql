/**
 * @name Filter with upper bound
 * @description This query excludes results that are
 *   safe because the upper bound of the size argument
 *   is less than or equal to the size of the destination
 *   buffer.
 * @problem.severity warning
 */

import cpp
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

// Let's add some extra columns, so that we can see a bit more information
// about the calls to copy_from_user.
//
// This shows that there are two fairly common patterns:
// 1. copy_from_user into a statically sized buffer, and the
//    upper bound of `sizeArg` shows that it is safe.
// 2. copy_from_user into a buffer that was allocated with kzalloc,
//    and the size argument of the kzalloc is the same as the
//    size argument of copy_from_user. These calls are safe.
from FunctionCall call, Expr destArg, Expr sizeArg
where call.getTarget().getName() = "copy_from_user"
and destArg = call.getArgument(0)
and sizeArg = call.getArgument(2)
select
  call,
  destArg.getType(),
  lowerBound(sizeArg),
  upperBound(sizeArg),
  call.getFile().getRelativePath()
