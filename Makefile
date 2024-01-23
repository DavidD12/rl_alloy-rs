
update:
	rustup update

compile:
	rustc file.rs

format:
	rustfmt file.rs

uninstall:
	# rustup self uninstall

create_projetc:
	cargo new my_project_name

build_project:
	cargo build

build_project_for_release:
	cargo build --release

run_project:
	cargo run

clean_project:
	cargo clean

check_project_compile:
	cargo check

update_project_crates:
	cargo update

create_dependency_doc_and_open_web_doc:
	cargo doc --open