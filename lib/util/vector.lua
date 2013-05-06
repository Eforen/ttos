-- Defines basic coordinate and vector class tables

-- # NOTE: Has been tested with 1.31, no conflicts, but the OEM function cannot be used in conjunction

function coord(inx, iny, inz)
	-- assume default values
	if inx == nil then inx = 0 end
	if iny == nil then iny = 0 end
	if inz == nil then inz = 0 end
	return {x=inx, y=iny, z=inz}
end

function vector(inx, iny, inz, ind)
	-- assume default values
	if inx == nil then inx = 0 end
	if iny == nil then iny = 0 end
	if inz == nil then inz = 0 end
	if ind == nil then ind = 0 end
	return {x=inx, y=iny, z=inz, dir=ind}
end