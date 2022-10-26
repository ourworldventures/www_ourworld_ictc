module main

import vweb
import os
import json
import time

pub struct App {
	vweb.Context
}

pub fn new_app() &App {
	mut app := &App{}
	static_folder := os.resource_abs_path('./static')
	app.mount_static_folder_at(static_folder, '/static')
	return app
}

pub fn main() {
	mut app := new_app()
	vweb.run(app, 8000)
}


pub fn (mut app App) index() vweb.Result {
	return $vweb.html()
}

pub struct Registration {
	name string
	email string
	org_website string
	plus_one string
	receive_communication string
	timestamp time.Time
}

pub fn (mut app App) exists() vweb.Result {
	return $vweb.html()
}

pub fn (mut app App) full() vweb.Result {
	return $vweb.html()
}

['/register'; post]
pub fn (mut app App) register(name string, email string, org_website string, plus_one string, receive_communication string) vweb.Result {
	files := os.ls('registrations') or { [] }
	// if files.len > 1000 {
	// 	return full()
	// }
	registration :=	Registration {
		name: name,
		email: email,
		org_website: org_website,
		plus_one: plus_one,
		receive_communication: receive_communication,
		timestamp: time.now()
	}
	path := 'registrations/${email}.txt'
	if os.exists(path) { return app.exists()}
	os.write_file(path, json.encode(registration)) or {println('error')}
	if files.len > 200 {
		return app.full()
	}
	return $vweb.html()
}