use rl_model::model::*;

pub mod skillset;
pub use skillset::*;

pub mod resource;
pub use resource::*;

pub mod event;
pub use event::*;

pub mod skill;
pub use skill::*;

pub fn to_alloy(model: &Model) -> String {
    let mut out = "".to_string();

    out += &skillsets_to_alloy(model);

    out
}
