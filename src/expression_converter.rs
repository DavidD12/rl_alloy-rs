use super::*;
use naming::*;
use rl_model::model::expr::Expr;

pub fn create_eq_neq_formula(
    left_member: &String,
    operator: &str,
    right_member: &String,
) -> String {
    format!("({} {} {})", left_member, operator, right_member)
}
pub fn create_and_or_implies_formula(
    left_member: &String,
    operator: &str,
    right_member: &String,
) -> String {
    format!("(({}) {} ({}))", left_member, operator, right_member)
}

pub fn get_alloy_formula(skillset: &Skillset, expr: &Expr) -> String {
    match expr {
        Expr::True => "{}".to_string(),
        Expr::False => "not {}".to_string(),

        Expr::ResourceEq(id, state) => {
            let resource = skillset.get(id.resolved()).unwrap();
            let state = skillset.get(state.resolved()).unwrap();
            create_eq_neq_formula(
                &resource_var(skillset, resource),
                "=",
                &resource_state(skillset, state),
            )
        }

        Expr::ResourceNe(id, state) => {
            let resource = skillset.get(id.resolved()).unwrap();
            let state = skillset.get(state.resolved()).unwrap();
            create_eq_neq_formula(
                &resource_var(skillset, resource),
                "!=",
                &resource_state(skillset, state),
            )
        }

        Expr::Not(a) => format!("!({})", get_alloy_formula(skillset, a)),
        Expr::And(a, b) => create_and_or_implies_formula(
            &get_alloy_formula(skillset, a),
            "and",
            &get_alloy_formula(skillset, b),
        ),
        Expr::Or(a, b) => create_and_or_implies_formula(
            &get_alloy_formula(skillset, a),
            "or",
            &get_alloy_formula(skillset, b),
        ),
        Expr::Implies(a, b) => create_and_or_implies_formula(
            &get_alloy_formula(skillset, a),
            "implies",
            &get_alloy_formula(skillset, b),
        ),
    }
}
