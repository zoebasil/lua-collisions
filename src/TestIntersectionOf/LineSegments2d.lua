local Constants = require(script.Parent.Parent.Constants)
local EPSILON = Constants.EPSILON

local function TestIntersectionOfLineSegments2d(a1, a2, b1, b2)
	local segAVector = a2 - a1
	local segBVector = b2 - b1

	local segmentVectorsCrossProduct = segAVector:Cross(segBVector)

	-- Declare variables for these expressions, since we use them more than once.
	local a1ToB1Vector = b1 - a1
	local a1ToB1VectorCrossSegAVector = (a1ToB1Vector):Cross(segAVector)

	-- segAIntersectionPointScalar * segAVector = Point of intersection on segment A
	-- segBIntersectionPointScalar * segBVector = Point of intersection on segment B
	local segAIntersectionPointScalar = (a1ToB1Vector):Cross(segBVector) / segmentVectorsCrossProduct
	local segBIntersectionPointScalar = a1ToB1VectorCrossSegAVector / segmentVectorsCrossProduct

	-- If the cross product of the two vectors of each segment is equal to 0,
	-- the line segments are either parallel or collinear (lie on the same line
	-- in 2d space). Otherwise, they have a possibility of intersecting at a
	-- discreet point.

	if segmentVectorsCrossProduct < EPSILON and segmentVectorsCrossProduct > -EPSILON then
		-- If the cross product of the vector from b1 to a1 and the vector of
		-- segment A is equal to 0, the line segments are collinear. Otherwise,
		-- they are parallel, and do not intersect.
		if a1ToB1VectorCrossSegAVector < EPSILON and a1ToB1VectorCrossSegAVector > -EPSILON then
			-- If b1 or b2 lies within the segmentAVector, the line segments
			-- overlap, and are intersecting. Otherwise, they're disjointed, and
			-- not intersecting.
			local segAVectorMagnitude = segAVector.Magnitude
			local segAVectorUnit = segAVector.Unit

			local b1Projection = segAVectorUnit:Dot(a1ToB1Vector) / segAVectorMagnitude
			if b1Projection >= 0 and b1Projection <= 1 then
				-- Line segments are collinear and overlapping, so they intersecti.
				return true
			end

			-- If b1 doesn't lie within the line segment, test again to see if b2 does.
			local b2Projection = segAVectorUnit:Dot(b2 - a1) / segAVectorMagnitude
			if b2Projection >= 0 and b2Projection <= 1 then

				-- Line segments are collinear and overlapping, so they intersect.
				return true
			end

			-- Lastly, check to see if segment a lies completely within segment b
			local a1Projection = segBVector.Unit:Dot(a1 - b1) / segBVector.magnitude
			if a1Projection >= 0 and a1Projection <= 1 then

				-- Line segments are collinear and overlapping, so they intersect.
				return true
			end

			-- Line segments are collinear and not overlapping, so they do not intersect.
			return false
		end

		return false
	end

	-- If the scalar for an intersection point lies within the range of 0 and 1,
	-- it means the intersection for that segment occurs within the span of the
	-- line segment. If the scalar for both intersection points lies within 0
	-- and 1, both points of intersection are on either line segment, and the
	-- lines intersect.
	return segAIntersectionPointScalar >= 0 and segAIntersectionPointScalar <= 1 and segBIntersectionPointScalar >= 0 and segBIntersectionPointScalar <= 1
end

return TestIntersectionOfLineSegments2d
