use rl_model::model::*;

pub fn get_alloy_formula(skillset: &Skillset, expr: &Expr) -> String {
    match expr {
        Expr::True => "true".to_string(),
        Expr::False => "false".into(),
        Expr::ResourceEq(id, state) => {
            let resource = skillset.get(id.resolved()).unwrap();
            let state = skillset.get(state.resolved()).unwrap();
            format!("{} = {}", resource.name(), state.name())
        }
        Expr::ResourceNe(_, _) => todo!(),
        Expr::Not(_) => todo!(),
        Expr::And(_, _) => todo!(),
        Expr::Or(_, _) => todo!(),
        Expr::Implies(_, _) => todo!(),
    }
}
