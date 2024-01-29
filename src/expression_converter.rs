use super::*;
use naming::*;
use rl_model::model::expr::Expr;

pub fn get_alloy_formula(skillset: &Skillset, expr: &Expr) -> String {
    // let out = " TODO ".to_string();
    // out
    match expr {
        Expr::True => "{}".to_string(),
        Expr::False => "not {}".to_string(),

        Expr::ResourceEq(id, state) => {
            let resource = skillset.get(id.resolved()).unwrap();
            let state = skillset.get(state.resolved()).unwrap();
            format!(
                "{} = {}",
                resource_var(skillset, resource),
                resource_state(skillset, state)
            )
        }

        Expr::ResourceNe(id, state) => {
            let resource = skillset.get(id.resolved()).unwrap();
            let state = skillset.get(state.resolved()).unwrap();
            format!(
                "{} != {}",
                resource_var(skillset, resource),
                resource_state(skillset, state)
            )
        }

        Expr::Not(a) => format!("!({})", get_alloy_formula(skillset, a)),
        Expr::And(a, b) => format!(
            "({}) and ({})",
            get_alloy_formula(skillset, a),
            get_alloy_formula(skillset, b)
        ),
        Expr::Or(a, b) => format!(
            "({}) or ({})",
            get_alloy_formula(skillset, a),
            get_alloy_formula(skillset, b)
        ),
        Expr::Implies(a, b) => format!(
            "({}) implies ({})",
            get_alloy_formula(skillset, a),
            get_alloy_formula(skillset, b)
        ),
    }
}
