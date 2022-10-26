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
	// mut app := new_app()
	// vweb.run(app, 8000)
	get_emails_from_dir('registrations')?
}


pub fn (mut app App) index() vweb.Result {
	return $vweb.html()
}

pub struct Registration {
	name                  string
	email                 string
	org_website           string
	plus_one              string
	receive_communication string
	timestamp             i64
}

pub fn (mut app App) exists() vweb.Result {
	return $vweb.html()
}

pub fn (mut app App) full() vweb.Result {
	return $vweb.html()
}

pub fn (mut app App) emailreq() vweb.Result {
	return $vweb.html()
}

pub fn (mut app App) invalid() vweb.Result {
	return $vweb.html()
}

['/register'; post]
pub fn (mut app App) register(name string, email string, org_website string, plus_one string, receive_communication string) vweb.Result {
	files := os.ls('registrations') or { [] }
	if files.len > 1000 {
		return app.full()
	}
	if email.len < 5 || !email.contains('@') || !email.contains('.') {
		return app.emailreq()
	}
	if email.len > 100 || name.len > 100 || org_website.len > 200 || email.contains('<script>') || name.contains('<script>') || org_website.contains('<script>'){
		return app.invalid()
	}

	registration :=	Registration {
		name: name,
		email: email,
		org_website: org_website,
		plus_one: plus_one,
		receive_communication: receive_communication,
		timestamp: time.now().unix_time()
	}
	path := 'registrations/${email}.txt'
	if os.exists(path) { return app.exists()}
	os.write_file(path, json.encode(registration)) or {println('error')}
	if files.len > 200 {
		return app.full()
	}
	return $vweb.html()
}


pub fn (mut app App) registrations() vweb.Result {
	key := os.getenv('ACCESS_KEY')
	password := app.get_header('password')
	if password != key {
		return app.html('not authorized')
	}
	path := 'registrations'
	files := os.ls(path) or { [] }
	mut resp := 'Total registrations: $files.len \n'
	for file in files {
		content := os.read_file('registrations/$file') or {'error'}
		resp += content
	}
	return app.html(resp)
}


pub fn get_emails_from_dir (path string) ?string {

	mut emails := []string

	mut files := os.ls(path)?// returns an array of strings

	for file in files {
		mut content := os.read_file('registrations/$file') or {'error'}
		registration := json.decode(Registration, content)?
		emails << registration.email
	}

	emails_string := emails.join(', ')

	println(emails_string)

	return emails_string

}

