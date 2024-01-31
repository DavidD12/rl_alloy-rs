pub use rl_model::model::*;

pub mod skillset;
pub use skillset::*;

pub mod resource;
pub use resource::*;

pub mod event;
pub use event::*;

pub mod skill;
pub use skill::*;

pub mod naming;

pub mod expression_converter;

pub mod running_constraint;
pub use running_constraint::*;

pub mod fairness_hypotheses;
pub use fairness_hypotheses::*;

pub fn to_alloy(model: &Model) -> String {
    let mut out = "module skillset_verif\n".to_string();

    out += &skillsets_to_alloy(model);

    out
}
