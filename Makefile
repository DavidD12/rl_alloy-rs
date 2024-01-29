
build_project:
	cargo build

build_project_for_release:
	cargo build --release

run_project:
	cargo run -- --file files/skillset.rl --out files/result.als

clean_project:
	cargo clean

check_project_compile:
	cargo check

update_project_crates:
	cargo update

create_dependency_doc_and_open_web_doc:
	cargo doc --open