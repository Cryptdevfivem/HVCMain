fx_version 'adamant'
game 'gta5'

this_is_a_map 'yes'


client_scripts {
	"client.lua",
    "cl_paleto.lua"
}

files {
	"stream/**/*.ytyp",
}

data_file 'DLC_ITYP_REQUEST' 'stream/**/*.ytyp'


client_script {
    'main.lua',
    'client.lua',
    "stream/main.lua",
}

files {
	'nutt_timecycle_mods_1.xml',
    'gabz_timecycle_mods_1.xml',
    'interiorproxies.meta',
    'k4mb1_ornate_bank.ytyp',
}

escrow_ignore {
    'stream/*.ytyp',
    'stream/*.ymap',
    'stream/*.ymf',
    'stream/*.ytd',
    'stream/ybn/*.ybn',
    'stream/ydr_rs/*.yft',
    'stream/ydr_ji/cayo_bar_bld_detail.ydr',
    'stream/ydr_ji/cayo_front_paintings.ydr',
    'stream/ydr_ji/cayo_mansion_library_detail.ydr',
    'stream/ydr_ji/cayo_mansion_main_paintings.ydr',
    'stream/ydr_ji/cayo_villa_paintings.ydr',
    'stream/vb_27_buildingsa.ydr',
    'stream/vb_27_detaildente.ydr',
    'stream/vb_27_ground.ydr',
    'stream/vb_27_nwem.ydr',
    'stream/vb_rd_road_r4f.ydr',
    'stream/tuner.ydr', -- Works for any file, stream or code
    'stream/it_cf_02_txt.ytd',
    'stream/*.ytyp',     -- Ignore all .ytyp files in that folder  
    'stream/*.ymap',     -- Ignore all .ymap files in that folder
    'stream/*.ymf',     -- Ignore all .ymf files in that folder
    'stream/*.ybn',     -- Ignore all .ybn files in that folder
    'stream/extra/*.ydr',   -- Ignore all .ydr files in any subfolder
}