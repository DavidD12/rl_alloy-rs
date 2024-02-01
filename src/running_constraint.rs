use super::*;
use naming::*;

pub fn running_constraint_to_alloy(skillset: &Skillset) -> String {
    let mut out = "".to_string();

    out += "\n// ==================== Running constraint ====================\n\n";

    // The enum
    out += &format!("enum {}_conc_event {{", skillset_fact_pred_name(skillset));
    out += &format!(
        "\n\t{}_lock_to_free_event,\n",
        skillset_fact_pred_name(skillset)
    );
    for skill in skillset.skills() {
        for invariant in skill.invariants() {
            out += &format!(
                "\tCheck_{}_{}_event,\n",
                skill_fact_pred_name(skillset, skill),
                invariant.name()
            );
        }
    }
    for event in skillset.events() {
        out += &format!("\t{}_event,\n", event_fact_pred_name(skillset, event));
    }
    for skill in skillset.skills() {
        out += &format!(
            "\t{}_idle_to_idle_event,\n",
            skill_fact_pred_name(skillset, skill)
        );
        out += &format!(
            "\t{}_idle_to_runn_event,\n",
            skill_fact_pred_name(skillset, skill)
        );
        out += &format!(
            "\t{}_runn_to_inte_event,\n",
            skill_fact_pred_name(skillset, skill)
        );
        out += &format!(
            "\t{}_inte_to_idle_event,\n",
            skill_fact_pred_name(skillset, skill)
        );
        for success in skill.successes() {
            out += &format!(
                "\t{}_runn_to_{}_event,\n",
                skill_fact_pred_name(skillset, skill),
                success_pred_name(success)
            );
        }
        for fail in skill.failures() {
            out += &format!(
                "\t{}_runn_to_{}_event,\n",
                skill_fact_pred_name(skillset, skill),
                failure_pred_name(fail)
            );
        }
    }
    out.truncate(out.len() - ",\n".len()); // To remove the last ",\n" statement
    out += "\n}\n\n";

    // The transition functions
    out += &format!(
        "fun is_event_{}_lock_to_free : set {}_conc_event {{\n\t{}_lock_to_free implies {{{}_lock_to_free_event}} else none\n}}\n",
        skillset_fact_pred_name(skillset),
        skillset_fact_pred_name(skillset),
        skillset_fact_pred_name(skillset),
        skillset_fact_pred_name(skillset)
    );
    for skill in skillset.skills() {
        for invariant in skill.invariants() {
            out += &format!(
                "fun is_event_Check_{}_{} : set {}_conc_event {{\n\tCheck_{}_{} implies {{Check_{}_{}_event}} else none\n}}\n",
                skill_fact_pred_name(skillset, skill),
                invariant.name(),
                skillset_fact_pred_name(skillset),
                skill_fact_pred_name(skillset, skill),
                invariant.name(),
                skill_fact_pred_name(skillset, skill),
                invariant.name()
            );
        }
    }
    for event in skillset.events() {
        out += &format!(
            "fun is_event_{} : set {}_conc_event {{\n\t{} implies {{{}_event}} else none\n}}\n",
            event_fact_pred_name(skillset, event),
            skillset_fact_pred_name(skillset),
            event_fact_pred_name(skillset, event),
            event_fact_pred_name(skillset, event)
        );
    }

    for skill in skillset.skills() {
        out += &format!(
            "fun is_event_{}_idle_to_idle : set {}_conc_event {{\n\t{}_idle_to_idle implies {{{}_idle_to_idle_event}} else none\n}}\n",
            skill_fact_pred_name(skillset, skill),
            skillset_fact_pred_name(skillset),
            skill_fact_pred_name(skillset, skill),
            skill_fact_pred_name(skillset, skill)
        );
        out += &format!(
            "fun is_event_{}_idle_to_runn : set {}_conc_event {{\n\t{}_idle_to_runn implies {{{}_idle_to_runn_event}} else none\n}}\n",
            skill_fact_pred_name(skillset, skill),
            skillset_fact_pred_name(skillset),
            skill_fact_pred_name(skillset, skill),
            skill_fact_pred_name(skillset, skill)
        );
        out += &format!(
            "fun is_event_{}_runn_to_inte : set {}_conc_event {{\n\t{}_runn_to_inte implies {{{}_runn_to_inte_event}} else none\n}}\n",
            skill_fact_pred_name(skillset, skill),
            skillset_fact_pred_name(skillset),
            skill_fact_pred_name(skillset, skill),
            skill_fact_pred_name(skillset, skill)
        );
        out += &format!(
            "fun is_event_{}_inte_to_idle : set {}_conc_event {{\n\t{}_inte_to_idle implies {{{}_inte_to_idle_event}} else none\n}}\n",
            skill_fact_pred_name(skillset, skill),
            skillset_fact_pred_name(skillset),
            skill_fact_pred_name(skillset, skill),
            skill_fact_pred_name(skillset, skill)
        );
        for success in skill.successes() {
            out += &format!(
                "fun is_event_{}_runn_to_{} : set {}_conc_event {{\n\t{}_runn_to_{} implies {{{}_runn_to_{}_event}} else none\n}}\n",
                skill_fact_pred_name(skillset, skill),
                success_pred_name(success),
                skillset_fact_pred_name(skillset),
                skill_fact_pred_name(skillset, skill),
                success_pred_name(success),
                skill_fact_pred_name(skillset, skill),
                success_pred_name(success)
            );
        }
        for fail in skill.failures() {
            out += &format!(
                "fun is_event_{}_runn_to_{} : set {}_conc_event {{\n\t{}_runn_to_{} implies {{{}_runn_to_{}_event}} else none\n}}\n",
                skill_fact_pred_name(skillset, skill),
                failure_pred_name(fail),
                skillset_fact_pred_name(skillset),
                skill_fact_pred_name(skillset, skill),
                failure_pred_name(fail),
                skill_fact_pred_name(skillset, skill),
                failure_pred_name(fail)
            );
        }
    }

    // The union function
    out += &format!(
        "\nfun {}_event_union : set {}_conc_event {{",
        skillset_fact_pred_name(skillset),
        skillset_fact_pred_name(skillset)
    );
    out += &format!(
        "\n\tis_event_{}_lock_to_free +\n",
        skillset_fact_pred_name(skillset)
    );
    for skill in skillset.skills() {
        for invariant in skill.invariants() {
            out += &format!(
                "\tis_event_Check_{}_{} +\n",
                skill_fact_pred_name(skillset, skill),
                invariant.name()
            );
        }
    }
    for event in skillset.events() {
        out += &format!("\tis_event_{} +\n", event_fact_pred_name(skillset, event));
    }
    for skill in skillset.skills() {
        out += &format!(
            "\tis_event_{}_idle_to_idle +\n",
            skill_fact_pred_name(skillset, skill)
        );
        out += &format!(
            "\tis_event_{}_idle_to_runn +\n",
            skill_fact_pred_name(skillset, skill)
        );
        out += &format!(
            "\tis_event_{}_runn_to_inte +\n",
            skill_fact_pred_name(skillset, skill)
        );
        out += &format!(
            "\tis_event_{}_inte_to_idle +\n",
            skill_fact_pred_name(skillset, skill)
        );
        for success in skill.successes() {
            out += &format!(
                "\tis_event_{}_runn_to_{} +\n",
                skill_fact_pred_name(skillset, skill),
                success_pred_name(success)
            );
        }
        for fail in skill.failures() {
            out += &format!(
                "\tis_event_{}_runn_to_{} +\n",
                skill_fact_pred_name(skillset, skill),
                failure_pred_name(fail)
            );
        }
    }
    out.truncate(out.len() - " +\n".len()); // To remove the last " +\n" statement
    out += "\n}\n\n";

    // The constraint fact
    out += &format!(
        "\nfact {}_always_some_event {{ always some {}_event_union }}\n",
        skillset_fact_pred_name(skillset),
        skillset_fact_pred_name(skillset),
    );

    out
}
