use super::*;
use naming::*;

pub fn fairness_hypotheses_to_alloy(skillset: &Skillset) -> String {
    let mut out = "".to_string();

    out += "\n// ==================== Fairness hypotheses ====================\n\n";

    // Running fairness
    for skill in skillset.skills() {
        out += &format!(
            "pred {}_running_fairness {{ always ( {} = {} implies eventually {} != {} ) }}\n",
            skill_fact_pred_name(skillset, skill),
            skill_var(skillset, skill),
            skill_state(skillset, "running"),
            skill_var(skillset, skill),
            skill_state(skillset, "running")
        );
    }
    out += &format!(
        "\nfact {}_running_fairness {{ always (\n",
        skillset_fact_pred_name(skillset)
    );
    for skill in skillset.skills() {
        out += &format!(
            "\t{}_running_fairness and \n",
            skill_fact_pred_name(skillset, skill),
        );
    }
    out.truncate(out.len() - " and ".len()); // To remove the last "and" statement
    out += "\n)}\n\n";

    // Interruption fairness
    for skill in skillset.skills() {
        out += &format!(
            "pred {}_interruption_fairness {{ always ( {} = {} implies eventually {} != {} ) }}\n",
            skill_fact_pred_name(skillset, skill),
            skill_var(skillset, skill),
            skill_state(skillset, "inter"),
            skill_var(skillset, skill),
            skill_state(skillset, "inter")
        );
    }
    out += &format!(
        "\nfact {}_interruption_fairness {{ always (\n",
        skillset_fact_pred_name(skillset)
    );
    for skill in skillset.skills() {
        out += &format!(
            "\t{}_interruption_fairness and \n",
            skill_fact_pred_name(skillset, skill),
        );
    }
    out.truncate(out.len() - " and ".len()); // To remove the last "and" statement
    out += "\n)}\n";

    out
}
