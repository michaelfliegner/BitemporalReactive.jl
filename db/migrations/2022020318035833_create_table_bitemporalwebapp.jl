module CreateTableBitempWebApp
import SearchLight: AbstractModel, DbId, query, save!
import SearchLight.Migrations:
    create_table, column, columns, primary_key, add_index, drop_table, add_indices
import SearchLightPostgreSQL
import Base: @kwdef
import Intervals, Dates, TimeZones, BitemporalPostgres
using BitemporalPostgres, Intervals,
    Dates, SearchLight, SearchLight.Transactions, SearchLightPostgreSQL, TimeZones
import InsuranceContracts
using InsuranceContracts
export up, down

function createRevisionsTriggerAndConstraint(
    trigger::Symbol,
    constraint::Symbol,
    table::Symbol,
)
    SearchLight.query("""
                      CREATE TRIGGER $trigger
                      BEFORE INSERT OR UPDATE ON $table
                      FOR EACH ROW EXECUTE PROCEDURE f_versionrange();
                      """)
    SearchLight.query(
        """
        ALTER TABLE $table
        ADD CONSTRAINT $constraint EXCLUDE USING GIST (ref_component WITH =, ref_valid WITH &&)
        """,
    )
end

function up()
    BitemporalPostgres.up()
    create_table(:contracts) do
        [
            column(:id, :bigserial, "PRIMARY KEY")
            column(:ref_history, :bigint, "REFERENCES histories(id) ON DELETE CASCADE")
            column(:ref_version, :bigint, "REFERENCES versions(id) ON DELETE CASCADE")
        ]
    end

    create_table(:contractRevisions) do
        [
            column(:id, :bigserial, "PRIMARY KEY")
            column(:ref_component, :bigint, "REFERENCES contracts(id) ON DELETE CASCADE")
            column(:ref_validfrom, :bigint, "REFERENCES versions(id) ON DELETE CASCADE")
            column(:ref_invalidfrom, :bigint, "REFERENCES versions(id) ON DELETE CASCADE")
            column(:ref_valid, :int8range)
            column(:description, :string)
        ]
    end

    createRevisionsTriggerAndConstraint(
        :cr_versions_trig,
        :contractsversionrange,
        :contractRevisions,
    )

    create_table(:productItems) do
        [
            column(:id, :bigserial, "PRIMARY KEY")
            column(:ref_history, :bigint, "REFERENCES histories(id) ON DELETE CASCADE")
            column(:ref_version, :bigint, "REFERENCES versions(id) ON DELETE CASCADE")
            column(:ref_super, :bigint, "REFERENCES contracts(id) ON DELETE CASCADE")
        ]
    end

    create_table(:productItemRevisions) do
        [
            column(:id, :bigserial, "PRIMARY KEY")
            column(
                :ref_component,
                :bigint,
                "REFERENCES productitems(id) ON DELETE CASCADE",
            )
            column(:position, :bigint)
            column(:ref_validfrom, :bigint, "REFERENCES versions(id) ON DELETE CASCADE")
            column(:ref_invalidfrom, :bigint, "REFERENCES versions(id) ON DELETE CASCADE")
            column(:ref_valid, :int8range)
            column(:description, :string)
        ]
    end

    createRevisionsTriggerAndConstraint(
        :pi_versions_trig,
        :pi_versionrange,
        :productitemRevisions,
    )

    create_table(:partners) do
        [
            column(:id, :bigserial, "PRIMARY KEY")
            column(:ref_history, :bigint, "REFERENCES histories(id) ON DELETE CASCADE")
            column(:ref_version, :bigint, "REFERENCES versions(id) ON DELETE CASCADE")
        ]
    end

    create_table(:partnerRevisions) do
        [
            column(:id, :bigserial, "PRIMARY KEY")
            column(:ref_component, :bigint, "REFERENCES partners(id) ON DELETE CASCADE")
            column(:ref_validfrom, :bigint, "REFERENCES versions(id) ON DELETE CASCADE")
            column(:ref_invalidfrom, :bigint, "REFERENCES versions(id) ON DELETE CASCADE")
            column(:ref_valid, :int8range)
            column(:description, :string)
        ]
    end

    createRevisionsTriggerAndConstraint(
        :pr_versions_trig,
        :pr_versionrange,
        :partnerRevisions,
    )

    create_table(:contractPartnerRoles) do
        [
            column(:id, :bigserial, "PRIMARY KEY")
            column(:domain, :string)
            column(:value, :string)
        ]
    end


    create_table(:contractPartnerRefs) do
        [
            column(:id, :bigserial, "PRIMARY KEY")
            column(:ref_history, :bigint, "REFERENCES histories(id) ON DELETE CASCADE")
            column(:ref_version, :bigint, "REFERENCES versions(id) ON DELETE CASCADE")
            column(:ref_super, :bigint, "REFERENCES contracts(id) ON DELETE CASCADE")
        ]
    end

    create_table(:contractPartnerRefRevisions) do
        [
            column(:id, :bigserial, "PRIMARY KEY")
            column(
                :ref_component,
                :bigint,
                "REFERENCES contractPartnerRefs(id) ON DELETE CASCADE",
            )
            column(:ref_role, :bigint, "REFERENCES contractpartnerroles(id) ON DELETE CASCADE")
            column(:ref_validfrom, :bigint, "REFERENCES versions(id) ON DELETE CASCADE")
            column(:ref_invalidfrom, :bigint, "REFERENCES versions(id) ON DELETE CASCADE")
            column(:ref_valid, :int8range)
            column(:description, :string)
            column(:ref_partner, :bigint, "REFERENCES partners(id) ON DELETE CASCADE")
        ]
    end

    createRevisionsTriggerAndConstraint(
        :cprr_versions_trig,
        :cprr_versionrange,
        :contractPartnerRefRevisions,
    )

    create_table(:tariffs) do
        [
            column(:id, :bigserial, "PRIMARY KEY")
            column(:ref_history, :bigint, "REFERENCES histories(id) ON DELETE CASCADE")
            column(:ref_version, :bigint, "REFERENCES versions(id) ON DELETE CASCADE")
        ]
    end

    create_table(:tariffRevisions) do
        [
            column(:id, :bigserial, "PRIMARY KEY")
            column(:ref_component, :bigint, "REFERENCES tariffs(id) ON DELETE CASCADE")
            column(:ref_validfrom, :bigint, "REFERENCES versions(id) ON DELETE CASCADE")
            column(:ref_invalidfrom, :bigint, "REFERENCES versions(id) ON DELETE CASCADE")
            column(:ref_valid, :int8range)
            column(:description, :string)
        ]
    end

    createRevisionsTriggerAndConstraint(
        :tr_versions_trig,
        :tr_versionrange,
        :tariffRevisions,
    )

    create_table(:productItemTariffRoles) do
        [
            column(:id, :bigserial, "PRIMARY KEY")
            column(:domain, :string)
            column(:value, :string)
        ]
    end

    create_table(:productItemTariffRefs) do
        [
            column(:id, :bigserial, "PRIMARY KEY")
            column(:ref_history, :bigint, "REFERENCES histories(id) ON DELETE CASCADE")
            column(:ref_version, :bigint, "REFERENCES versions(id) ON DELETE CASCADE")
            column(:ref_super, :bigint, "REFERENCES productitems(id) ON DELETE CASCADE")
        ]
    end

    create_table(:productItemTariffRefRevisions) do
        [
            column(:id, :bigserial, "PRIMARY KEY")
            column(:ref_component, :bigint, "REFERENCES productItemTariffRefs(id) ON DELETE CASCADE",)
            column(:ref_role, :bigint, "REFERENCES productitemtariffroles(id) ON DELETE CASCADE")
            column(:ref_validfrom, :bigint, "REFERENCES versions(id) ON DELETE CASCADE")
            column(:ref_invalidfrom, :bigint, "REFERENCES versions(id) ON DELETE CASCADE")
            column(:ref_valid, :int8range)
            column(:description, :string)
            column(:ref_tariff, :bigint, "REFERENCES tariffs(id) ON DELETE CASCADE")
        ]
    end

    createRevisionsTriggerAndConstraint(
        :pitrr_versions_trig,
        :pitrr_versionrange,
        :productItemTariffRefRevisions,
    )

    create_table(:productItemPartnerRoles) do
        [
            column(:id, :bigserial, "PRIMARY KEY")
            column(:domain, :string)
            column(:value, :string)
        ]
    end

    create_table(:productItemPartnerRefs) do
        [
            column(:id, :bigserial, "PRIMARY KEY")
            column(:ref_history, :bigint, "REFERENCES histories(id) ON DELETE CASCADE")
            column(:ref_version, :bigint, "REFERENCES versions(id) ON DELETE CASCADE")
            column(:ref_super, :bigint, "REFERENCES productitems(id) ON DELETE CASCADE")
        ]
    end

    create_table(:productItemPartnerRefRevisions) do
        [
            column(:id, :bigserial, "PRIMARY KEY")
            column(
                :ref_component,
                :bigint,
                "REFERENCES productItemPartnerRefs(id) ON DELETE CASCADE",
            )
            column(:ref_role, :bigint, "REFERENCES productitempartnerroles(id) ON DELETE CASCADE")
            column(:ref_validfrom, :bigint, "REFERENCES versions(id) ON DELETE CASCADE")
            column(:ref_invalidfrom, :bigint, "REFERENCES versions(id) ON DELETE CASCADE")
            column(:ref_valid, :int8range)
            column(:description, :string)
            column(:ref_partner, :bigint, "REFERENCES partners(id) ON DELETE CASCADE")
        ]
    end

    createRevisionsTriggerAndConstraint(
        :piprr_versions_trig,
        :piprr_versionrange,
        :productItemPartnerRefRevisions,
    )

    contractpartnerroles = map(["Policy Holder" "Premium Payer"]) do val
        save!(ContractPartnerRole(value=val))
    end


    productitemtariffroles = map(["Main Coverage - Life" "Supplementary Coverage - Occupational Disablity"]) do val
        save!(ProductItemTariffRole(value=val))
    end

    productitempartnerroles = map(["Insured Person" "2nd Insured Person"]) do val
        save!(ProductItemPartnerRole(value=val))
    end

end

function down()
    BitemporalPostgres.DDL.down()
    drop_table(:contractRevisions)
    drop_table(:contracts)
    drop_table(:contractProductItems)
    drop_table(:contractProductItemRevisions)
    drop_table(:contractPartnerRefRevisions)
    drop_table(:contractPartnerRefs)
    drop_table(:productItemTariffRefRevisions)
    drop_table(:productItemTariffRefs)
    drop_table(:productItemPartnerRefRevisions)
    drop_table(:productItemPartnerRefs)
    drop_table(:partnerRevisions)
    drop_table(:partners)
    drop_table(:tariffRevisions)
    drop_table(:tariffs)

end
end
