use clap::Parser;
use rl_alloy::to_alloy;
use rl_model::*;
use std::env;
use std::fs;

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// robot language file
    #[arg(short, long)]
    rlfile: String,
    /// result file
    #[arg(short, long)]
    outputfile: String,
    /// verbose level
    #[arg(short, long, default_value_t = 1)]
    verbose: u8,
}
fn main() {
    let args = Args::parse();
    if args.verbose > 0 {
        //
        if env::var("RUST_LOG").is_err() {
            env::set_var("RUST_LOG", "info")
        }
        env_logger::init();
    }
    //
    if let Ok(model) = load_model(&args.rlfile) {
        if args.verbose >= 3 {
            println!("\n--------------------------------------------------\n");
            println!("{}", model);
        }
        if args.verbose >= 2 {
            println!("\n--------------------------------------------------\n");
            println!("{}", model);
        }

        let alloy = to_alloy(&model);
        // println!("{}", alloy);
        let _ = fs::write(&args.outputfile, alloy);
    }
}
