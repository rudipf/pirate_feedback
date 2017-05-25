-- Convert a database from Pirate Feedback v1.0.0-1.1.3 to v1.2.0

-- See INSTALL for instructions!
-- After running this script the database schema must be recreated.

-- After recreation of the schema run:
-- BEGIN; SET TRANSACTION ISOLATION LEVEL REPEATABLE READ; SELECT "set_harmonic_initiative_weights"("id") FROM "issue"; COMMIT;


BEGIN;

-- changes from liquid feedback core v2.0.12 to v2.2.3

ALTER TABLE "privilege" RENAME COLUMN "voting_right_manager" TO "member_manager";
ALTER TABLE "privilege" ADD COLUMN "initiative_right" BOOLEAN NOT NULL DEFAULT TRUE;
UPDATE "privilege" SET "initiative_right" = "voting_right";

DROP TABLE "rendered_issue_comment";
DROP TABLE "issue_comment";
DROP TABLE "rendered_voting_comment";
DROP TABLE "voting_comment";

DROP VIEW "issue_with_ranks_missing";
DROP VIEW "open_issue";
ALTER TABLE "issue" DROP COLUMN "ranks_available";

ALTER TABLE "policy"     ADD COLUMN "polling" BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE "initiative" ADD COLUMN "polling" BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE "contingent" ADD COLUMN "polling" BOOLEAN DEFAULT FALSE;

-- pirate feedback changes

ALTER TABLE "draft" ADD COLUMN "name" TEXT;
UPDATE "draft" SET "name" = "initiative"."name" FROM "initiative" WHERE "draft"."initiative_id" = "initiative"."id";

ALTER TABLE "area" DROP COLUMN "member_weight";

COMMIT;
