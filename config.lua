Config = {}

Config.RangeCheck = 15.0

Config.Garages = {
    ["A"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(211.85960388184, -934.98852539063, 24.275939941406)
            },
            ["vehicle"] = {
                ["position"] = vector3(212.23542785645, -944.20251464844, 24.141599655151), 
                ["heading"] = 140.0
            }
        },
        ["camera"] = {  -- camera is not needed, but cool
            ["x"] = 211.38734436035, 
            ["y"] = -950.86059570313, 
            ["z"] = 26.649261474609, 
            ["rotationX"] = -18.99212577939, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = -3.4645672738552
        }
    },
    ["B"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-169.65344238281, -631.27374267578, 32.424320220947)
            },
            ["vehicle"] = {
                ["position"] = vector3(-166.88215637207, -625.09649658203, 32.42440032959), 
                ["heading"] = 65.0
            }
        },
        ["camera"] = { ["x"] = -165.86602783203, ["y"] = -621.67376708984, ["z"] = 34.195068359375, ["rotationX"] = -35.622046887875, ["rotationY"] = 0.0, ["rotationZ"] = -201.54330666363 }
    },
    ["C"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(279.02288818359, -346.09643554688, 44.91987991333)
            },
            ["vehicle"] = {
                ["position"] = vector3(292.94638061523, -331.13787841797, 44.919876098633), 
                ["heading"] = 160.0
            }
        },
        ["camera"] = { ["x"] = 283.55877685547, ["y"] = -333.10021972656, ["z"] = 52.251888275146, ["rotationX"] = -39.874015718699, ["rotationY"] = 0.0, ["rotationZ"] = -68.629920691252 }
    },
    ["D"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(1737.6774902344, 3709.6628417969, 34.136455535889)
            },
            ["vehicle"] = {
                ["position"] = vector3(1727.8391113281, 3711.0688476563, 34.247383117676), 
                ["heading"] = 20.0
            }
        },
        ["camera"] = { ["x"] = 1729.46484375, ["y"] = 3706.9931640625, ["z"] = 35.945613861084, ["rotationX"] = -24.913385644555, ["rotationY"] = 0.0, ["rotationZ"] = 19.999999970198 }
    },
    ["E"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(31.024526596069, 6441.849609375, 31.42527961731)
            },
            ["vehicle"] = {
                ["position"] = vector3(37.408683776855, 6446.1767578125, 31.425289154053), 
                ["heading"] = 220.0
            }
        },
        ["camera"] = { ["x"] = 34.427845001221, ["y"] = 6450.4873046875, ["z"] = 34.081153869629, ["rotationX"] = -31.590551137924, ["rotationY"] = 0.0, ["rotationZ"] = -136.72440898418 }
    },
    ["F"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-1810.2325439453, -343.77047729492, 43.600635528564)
            },
            ["vehicle"] = {
                ["position"] = vector3(-1810.3586425781, -337.59701538086, 43.572200775146), 
                ["heading"] = 310.0
            }
        },
        ["camera"] = { ["x"] = -1813.6220703125, ["y"] = -340.80096435547, ["z"] = 46.782543182373, ["rotationX"] = -37.070866391063, ["rotationY"] = 0.0, ["rotationZ"] = -43.874015644193 }
    }
}

Config.Labels = {
    ["menu"] = "~INPUT_CONTEXT~ Öppna garage %s.",
    ["vehicle"] = "~INPUT_CONTEXT~ Kör in '%s' i ditt garage."
}

Config.Trim = function(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

Config.AlignMenu = "right" -- this is where the menu is located [left, right, center, top-right, top-left etc.]