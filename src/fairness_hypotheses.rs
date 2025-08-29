use super::*;
use naming::*;

pub fn generic_fairness_hypotheses_to_alloy(
    skillset: &Skillset,
    pred_fairness_name: &str,
    skill_state_name: &str,
) -> String {
    let mut out = String::new();

    for skill in skillset.skills() {
        out += &format!(
            "pred {}_{}_fairness {{ always ( {} = {} implies eventually {} != {} ) }}\n",
            skill_fact_pred_name(skillset, skill),
            pred_fairness_name,
            skill_var(skillset, skill),
            skill_state(skillset, skill_state_name),
            skill_var(skillset, skill),
            skill_state(skillset, skill_state_name)
        );
    }
    out += &format!(
        "\nfact {}_{}_fairness {{ always (\n",
        skillset_fact_pred_name(skillset),
        pred_fairness_name
    );
    for skill in skillset.skills() {
        out += &format!(
            "\t{}_{}_fairness and \n",
            skill_fact_pred_name(skillset, skill),
            pred_fairness_name
        );
    }
    out.truncate(out.len() - " and ".len()); // To remove the last "and" statement
    out += "\n)}\n\n";

    out
}

pub fn fairness_hypotheses_to_alloy(skillset: &Skillset) -> String {
    let mut out = String::new();

    out += "\n// ==================== Fairness hypotheses ====================\n\n";

    // Running fairness
    out += &generic_fairness_hypotheses_to_alloy(skillset, "running", "running");
    // for skill in skillset.skills() {
    //     out += &format!(
    //         "pred {}_running_fairness {{ always ( {} = {} implies eventually {} != {} ) }}\n",
    //         skill_fact_pred_name(skillset, skill),
    //         skill_var(skillset, skill),
    //         skill_state(skillset, "running"),
    //         skill_var(skillset, skill),
    //         skill_state(skillset, "running")
    //     );
    // }
    // out += &format!(
    //     "\nfact {}_running_fairness {{ always (\n",
    //     skillset_fact_pred_name(skillset)
    // );
    // for skill in skillset.skills() {
    //     out += &format!(
    //         "\t{}_running_fairness and \n",
    //         skill_fact_pred_name(skillset, skill),
    //     );
    // }
    // out.truncate(out.len() - " and ".len()); // To remove the last "and" statement
    // out += "\n)}\n\n";

    // Interruption fairness
    out += &generic_fairness_hypotheses_to_alloy(skillset, "interruption", "inter");
    // for skill in skillset.skills() {
    //     out += &format!(
    //         "pred {}_interruption_fairness {{ always ( {} = {} implies eventually {} != {} ) }}\n",
    //         skill_fact_pred_name(skillset, skill),
    //         skill_var(skillset, skill),
    //         skill_state(skillset, "inter"),
    //         skill_var(skillset, skill),
    //         skill_state(skillset, "inter")
    //     );
    // }
    // out += &format!(
    //     "\nfact {}_interruption_fairness {{ always (\n",
    //     skillset_fact_pred_name(skillset)
    // );
    // for skill in skillset.skills() {
    //     out += &format!(
    //         "\t{}_interruption_fairness and \n",
    //         skill_fact_pred_name(skillset, skill),
    //     );
    // }
    // out.truncate(out.len() - " and ".len()); // To remove the last "and" statement
    // out += "\n)}\n";

    out
}
