use rl_model::model::*;

pub mod skillset;
pub use skillset::*;

pub mod resource;
pub use resource::*;

pub mod validate;
pub use validate::*;

pub mod event;

pub mod skill;

pub mod naming;

pub mod expression_converter;


pub fn to_alloy(model: &Model) -> String {
    let mut out = "module skillset_verif\n".to_string();

    out += &skillsets_to_alloy(model);

    out
}
