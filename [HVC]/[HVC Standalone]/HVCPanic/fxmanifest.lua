









-- Inferno Collection Police Panic Version 1.22 Beta
--
-- Copyright (c) 2019 - 2020, Christopher M, Inferno Collection. All rights reserved.
--
-- This project is licensed under the following:
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to use, copy, modify, and merge the software, under the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. THE SOFTWARE MAY NOT BE SOLD.
--

name "Police Panic - Inferno Collection"

description "The Police Panic script is a simple Standalone script that allows Officers to tune into a \"Panic Channel\", which allows them to receive Panic Button activations, as well as activate their own Panic Button."

author "Inferno Collection (inferno-collection.com)"

version "1.22 Beta"

url "https://inferno-collection.com"

dependencies {
	'hvc'
}


client_scripts {
	"@hvc/lib/utils.lua",
	"lib/Tunnel.lua",
	"lib/Proxy.lua",
	"client.lua",
  } 

server_scripts {
    "@hvc/lib/utils.lua",
    "server.lua",
}

ui_page "html/index.html"

files {
	"whitelist.json",
	"html/index.html",
	"html/sounds/*.ogg"
}

fx_version "bodacious"

game "gta5"