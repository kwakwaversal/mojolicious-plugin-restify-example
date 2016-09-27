-- 1 up
SET CHECK_FUNCTION_BODIES TO FALSE;

CREATE OR REPLACE FUNCTION "trig_stats_update" ()
RETURNS trigger AS
$BODY$
-- Trigger updating the stats table when games are inserted, updated or deleted.
--
DECLARE

BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    PERFORM func_update_stats(ARRAY[NEW.winner_id, NEW.loser_id]::uuid[]);
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    PERFORM func_update_stats(ARRAY[OLD.winner_id, OLD.loser_id]::uuid[]);
    RETURN OLD;
  END IF;
END;
$BODY$
	LANGUAGE PLpgSQL
	CALLED ON NULL INPUT
	IMMUTABLE
	EXTERNAL SECURITY DEFINER;




CREATE OR REPLACE FUNCTION "func_update_stats" (IN player_ids uuid[])
RETURNS bool AS
$BODY$
-- Updates the stats table based on the array of players_id passed.
--
DECLARE
  player_id     uuid;
  r             vw_stats%rowtype; -- or record
  new_stats_id  uuid;
BEGIN
  FOREACH player_id IN ARRAY $1
  LOOP
    -- In postgres 9.5 this could be 'ON CONFLICT DO' which is UPSERT. I
    -- cannot do that because TravisCI is only on 9.4.
    DELETE FROM stats
      WHERE stats_id=(SELECT stats_id FROM players WHERE players_id=player_id);

    SELECT INTO r * FROM vw_stats
      WHERE players_id=player_id;
    IF FOUND THEN
      new_stats_id = gen_random_uuid();
      INSERT INTO stats(stats_id, games, wins, losses, avg_score, max_score, updated)
        VALUES(new_stats_id, r.games, r.wins, r.losses, r.avg_score, r.max_score, NOW());

      UPDATE players SET stats_id=new_stats_id WHERE players_id=player_id;
    ELSE
      RAISE NOTICE 'Unable to find % in vw_stats', player_id;
    END IF;
  END LOOP;

  RETURN true;
END;
$BODY$
	LANGUAGE PLpgSQL
	CALLED ON NULL INPUT
	VOLATILE
	EXTERNAL SECURITY DEFINER;




SET CHECK_FUNCTION_BODIES TO TRUE;


DROP TABLE IF EXISTS "players" CASCADE;

CREATE TABLE "players" (
	"players_id" uuid NOT NULL,
	"stats_id" uuid,
	"forename" varchar NOT NULL,
	"surname" varchar NOT NULL,
	"nickname" varchar NOT NULL,
	"email" varchar NOT NULL,
	"tel_no" varchar NOT NULL,
	"created" timestamp with time zone NOT NULL DEFAULT NOW(),
	"updated" timestamp with time zone NOT NULL DEFAULT NOW(),
	"status" varchar NOT NULL DEFAULT 'Active',
	CONSTRAINT "pk_players" PRIMARY KEY("players_id"),
	CONSTRAINT "con_players_status" CHECK(status IN ('Active', 'Deleted', 'Suspended', 'Trashed'))
);

COMMENT ON TABLE "players" IS 'Player details (including contact information).';

COMMENT ON COLUMN "players"."players_id" IS 'Primary key. UUIDs are generally better for futureproofing.';

COMMENT ON COLUMN "players"."forename" IS 'The real forename of the member.';

COMMENT ON COLUMN "players"."surname" IS 'The real surname of the member.';

COMMENT ON COLUMN "players"."nickname" IS 'Everyone likes a pseudonym.';

COMMENT ON COLUMN "players"."email" IS 'We need to be able to contact our members.';

COMMENT ON COLUMN "players"."tel_no" IS 'Contact number for the member (upselling?)';

COMMENT ON COLUMN "players"."created" IS 'When the member was created.';

COMMENT ON COLUMN "players"."updated" IS 'When the details were last updated.';

COMMENT ON COLUMN "players"."status" IS 'Active, Deleted, Suspended, Trashed.';

INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('0CA4C5E0-C822-3799-4521-1BF02543E702','Paul','Williams','Kwakwaversal','kwakwaversal@gmail.com','07763 837 745');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('037B2FB6-6573-0F33-B5EA-D902413FE805','Demetria','Barr','Rylee','eu@nec.org','(0111) 172 1409');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('87431F35-F5F8-8642-D1B2-35C8880016D0','Karina','Washington','Isabelle','Aenean@fermentumfermentum.com','0800 1111');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('F9E93A6A-72BE-6B68-3836-E71B57662A0B','Zena','Manning','Amela','Duis.elementum@metus.co.uk','070 1525 9341');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('A1395323-A908-3608-3F84-2AC3BCB2E9AF','Amena','Raymond','Germaine','consectetuer.euismod@maurissapiencursus.org','(011963) 33430');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('B71D8E79-546F-6AFB-573B-EB76C8F568FB','Marcia','Serrano','Yen','risus.Morbi@hymenaeos.org','056 9342 3939');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('C26D94A0-28DC-973C-4185-642077F32996','Veda','Macias','Tamekah','erat.Sed.nunc@Maurismolestiepharetra.co.uk','(014673) 43897');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('DE4479E2-4BA0-8129-129C-9EE55901EFFB','Maya','Castillo','Carter','In.mi.pede@Duisacarcu.org','(029) 0611 6699');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('A5B40FB1-CAEA-1E70-C2BA-73551D8A9716','Rafael','Paul','Ocean','risus.Donec@infaucibus.ca','(01336) 468131');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('DB2CC87A-E63A-1890-3611-C2A9BBDCBC39','Rachel','Wilder','Reese','odio.a@risus.com','0800 214448');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('7EB00F48-3B90-B8EB-5BD2-E30D5C51D4B0','Chava','Fischer','Carissa','ipsum@penatibuset.org','0500 276665');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('104AD2DA-3EBD-AFB7-6B55-D24C3C20B5C9','Dale','Stewart','Willow','fames.ac.turpis@Sedauctor.org','0384 190 5916');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('EF2BAAA0-39F0-8FC9-3904-616FB8BCA8C7','Beck','Mccullough','Wyoming','Etiam@infaucibusorci.com','0845 46 49');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('AACE42D3-5C42-335F-4ACB-F4FC90F063AB','Valentine','Ford','Bertha','Quisque@enim.edu','0964 726 8749');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('498B7460-59FA-CBE2-4C3E-81F8AC39D291','Sigourney','Sims','Hedley','malesuada@lobortisrisus.org','0845 46 44');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('5F575DF0-5C38-7BA9-A6B2-A5BEDB440331','Yasir','Dean','Cameron','sem.Pellentesque@Aliquamgravidamauris.com','0395 272 4040');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('4B9C71DA-84F2-E00D-0E2E-6EEB12B7EAE4','Gillian','Hogan','Karen','ut.nulla.Cras@Vivamuseuismod.net','(019141) 23859');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('8D7AE85A-ED77-EAF2-EDFF-A26025189974','Libby','Huber','Zephr','Mauris@nisiaodio.co.uk','0313 607 1838');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('719EBE98-0746-B686-FCBE-CD4E395C2742','Patricia','William','Anthony','Integer.vitae@ligula.co.uk','0845 46 49');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('195B97BF-9B00-62C9-A9F0-C74DB1910E34','Amethyst','Hendricks','Giacomo','Donec@ornareFusce.net','070 6579 1488');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('4D36F8E2-CEDA-EE6D-864E-3CBA6F0FC1FA','MacKensie','Baker','Cassidy','dui.Fusce.diam@Donecsollicitudin.org','(0113) 136 7221');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('853D2888-CA67-0501-8C3E-A6A99196D54D','Nissim','Glass','Yolanda','ac.turpis@penatibus.com','056 1931 5215');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('A0A52D15-905E-72EC-DC98-B5CF82A29325','Hamish','Fisher','Denton','mauris.blandit.mattis@sitamet.com','(0161) 193 0717');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('CBA1DF8F-6DAA-D2AD-2ED6-3BD85A975828','Dean','Sawyer','Bianca','est@diam.ca','(014143) 82778');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('948EFB16-7F41-3998-66E5-A7305C2D130F','Amity','Fleming','Vanna','Cras@mollisInteger.ca','0845 46 48');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('0C4C587B-BDB7-B050-9FA6-3D85D67F9452','Veronica','Lott','Norman','vel.turpis@risusa.ca','(0171) 955 3674');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('B742C3D9-4119-6DEA-C9BA-66238CB5BDC9','Nayda','Cochran','Xantha','eros@euismodet.edu','07545 389177');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('88017541-82C1-9669-9CF4-3DAA84B41A7D','Mercedes','Bernard','Jeanette','aliquet@Seddiamlorem.org','0800 1111');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('158C9E1D-E92F-1EAC-BF56-4663F90A4267','Giselle','Bright','Caesar','amet.consectetuer@velitduisemper.net','076 6745 1571');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('3902C6A1-9753-6FDE-3FD2-557BBF0FA2CD','Ivor','Mayo','Daria','Curabitur.ut.odio@amifringilla.net','07927 549080');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('98BAE89A-FC6F-E93F-8620-B0484ABD500D','Kermit','Roberson','Alexandra','arcu@magna.com','07624 629632');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('D8BC29A0-C116-8774-AA5B-CF44AF872B9A','Aimee','Booker','Courtney','volutpat.ornare.facilisis@sociosquadlitora.net','0900 895 6795');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('490E62FB-C6E4-50B0-F3F8-3EC5F75B49FF','Bryar','Tillman','Hilary','Cras@Nam.net','0900 726 3864');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('E32DE969-8A0B-C96E-86C1-32C35BEF715B','Nomlanga','Jackson','Conan','nulla.vulputate.dui@quis.com','(016520) 43708');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('5987BAE0-4293-40A4-B362-335D2BF2B713','Quinlan','Wolf','Fay','tempus@enimsitamet.ca','0845 46 43');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('6E6A4316-04C3-5C1D-215C-17D6033A8DE3','Xaviera','Wilder','Lawrence','adipiscing@adui.edu','0800 1111');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('8D88B2C1-A178-9D89-2F3A-4886B189A089','Marcia','Brown','Adam','libero@Nullainterdum.edu','076 8484 0578');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('9BD78D36-2DBB-6E2F-2B29-B313B3469A7D','Lara','Puckett','Iona','Duis@Morbivehicula.org','0845 46 44');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('6C292E9B-AB36-7D68-375F-E54A0CE2FF1E','Mona','Callahan','Evangeline','augue@mi.co.uk','07236 608779');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('60FE30C6-7F8E-A863-667D-48C16B830F0F','Rudyard','Shelton','Emerson','euismod.mauris.eu@noncursusnon.ca','07624 100334');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('B861066F-A837-2B52-23B4-3D2E3EEDAF81','Hyacinth','Ayala','Ferris','magnis.dis.parturient@Duis.net','0873 892 6998');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('8E4C8AED-F943-B034-8C3E-90F2B051F017','Quamar','English','Cassady','urna@Naminterdumenim.edu','056 8770 0864');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('94DD0AEE-D2B5-E70D-3E4C-1C1A8065551A','Rafael','Golden','Ori','sed@nonummyultriciesornare.org','0800 1111');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('EA2ACEFB-BA5C-C0E1-2A66-A3123BA33015','Preston','Bradford','Andrew','ligula.Nullam@duinectempus.com','0800 917465');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('DC913A93-62CB-7A4F-D8EA-8E9672200D09','Silas','Walker','William','convallis.ante.lectus@semper.org','0500 571166');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('F1F6AF32-524A-D242-DF76-EAB9A6C7A190','Thor','Vaughn','Amal','leo.elementum@ornare.org','(0131) 642 6265');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('CD13AE3C-9FCF-BBB7-7132-31494276C399','Camilla','Tucker','Iliana','Duis.ac.arcu@auctor.org','056 7819 3263');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('3EB770D3-21AD-7E9D-823E-FD52A056DFA4','Ryder','Tran','Gail','Cras.pellentesque@purusMaecenas.co.uk','(01422) 992874');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('F3CC55B1-350C-A805-B3DB-6E1EA351FA38','Aaron','Wilder','Halee','Mauris@arcu.ca','0800 1111');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('6E75E29E-2073-CE56-000F-148FAB4ADC06','Sydnee','Summers','Wylie','arcu.imperdiet.ullamcorper@dictumplacerat.ca','(0121) 566 9674');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('ED665153-B471-2AF4-0966-2BD2986B8F34','Ariel','Baldwin','Kathleen','sagittis.lobortis.mauris@elementumategestas.edu','07624 152425');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('6E178A3A-22E9-0C33-860F-4D45602BB5B1','Kitra','Cox','Imelda','varius.Nam.porttitor@tristique.co.uk','056 7796 1238');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('C46188D7-9E90-0D7D-76EF-67EFE2A64788','Sebastian','Vinson','Rina','neque@nasceturridiculus.co.uk','(01631) 01042');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('3CAD818E-CAFD-1C21-2C75-44B5B4AE4F3A','Idona','Cantrell','Avye','risus.Morbi.metus@Sed.org','070 8057 4081');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('C0EC3DD8-8BCA-C934-CCFE-B24B090EDCF9','Shelby','Bowen','Karyn','vehicula.aliquet@sollicitudin.com','0845 46 43');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('379504D9-8306-0600-44C5-63C6A74B8A2C','Clementine','Marquez','Alea','tincidunt.tempus.risus@elit.ca','0800 1111');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('6AEDA4A0-044A-86D0-3C18-860D1E1537B8','Nola','Kaufman','Paki','porttitor@Cumsociisnatoque.co.uk','0800 072893');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('E458A999-829B-A95D-DA82-22C2289EEAF4','Timothy','Cline','John','Integer.urna.Vivamus@Fuscealiquamenim.net','(018731) 11832');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('A380BA35-B563-D891-A41E-738FA272A460','Donovan','Page','Hayden','ullamcorper.nisl.arcu@purus.org','0800 1111');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('F00C5BD2-C425-07B9-9B7C-302CE0899DDE','Leandra','Gonzales','Graham','neque.venenatis@dictummi.net','076 0180 3748');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('86F8F599-760C-458C-7FAE-9CBAB35BF5A9','Linda','Elliott','Dai','sagittis.felis.Donec@bibendum.edu','0353 579 1243');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('C0CE6100-B0A9-83E4-704F-E9BF2D5173F8','Grace','Elliott','Maggy','gravida.mauris@placerategetvenenatis.com','(01084) 49394');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('94122F27-DBE5-CD80-C993-9DAF58119E80','Whitney','Clements','Kirby','convallis.convallis.dolor@acipsum.com','076 3401 3923');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('5F8397B0-56FB-BD16-0522-FAEF1A2FA713','Zena','Buchanan','Blossom','Curabitur.egestas@lobortistellus.net','0820 116 0785');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('9FA4EE37-EEA6-AFDB-EFFE-E7EA584A6F9E','Heidi','Galloway','Giselle','Proin@enim.net','0800 237348');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('9459F41A-B827-69EE-7C7B-C441DCA1575B','Todd','Callahan','Cherokee','amet.ultricies@etnuncQuisque.net','(01310) 94710');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('1237C7CA-F1B8-1012-848D-7521B9B81974','Cole','Carpenter','Hilel','Donec@dis.net','0500 687809');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('6D996998-5528-7DBB-08F8-8220BA3BA5E2','Logan','Salinas','MacKensie','Donec.elementum@neque.edu','056 4458 7905');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('C5909D1F-E962-04E5-5E35-EC1473AC8097','Jescie','Gilmore','Constance','Nunc.sollicitudin.commodo@neque.com','(016977) 1449');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('6CC7EBE7-F0D0-DBAC-ED50-A458B3BA61F0','Germaine','Stark','Sylvia','ipsum.Suspendisse.non@ut.net','(016977) 9764');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('FC4DD244-5FAD-ACA2-A7FA-30D36CE83551','Jaquelyn','Matthews','Gay','augue@bibendum.com','(023) 8520 7520');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('8E87AA29-B88F-D773-56F0-53F86836719A','Tucker','Lang','Bryar','Integer@luctusCurabitur.org','0800 268 8455');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('7760E724-9496-5936-E5D1-1E8EC3F84013','Holly','Lott','Maile','sem.ut.dolor@Utsemper.com','0800 1111');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('3F5D2C20-0F35-76A3-351D-3230D1CC80DF','Leah','Mcmillan','Uma','tincidunt.pede.ac@etmagnis.com','(01881) 40486');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('32B33816-A2AB-8E98-6A9A-8157A0DB514F','Tasha','Trujillo','Guinevere','purus.mauris@laoreetlectusquis.net','(013231) 96140');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('1D3FCEF9-EBBE-FEC3-BC4B-EF930CE0B9CD','Orson','Fernandez','Rooney','erat@necmollis.net','07624 886205');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('479C551F-E6CF-F81D-1687-0ED5686D3485','Aurelia','Oneil','Victoria','nec.leo.Morbi@feugiatnonlobortis.net','0500 463864');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('7C2C5EE4-89B2-73B8-5357-5DC1819EEAC8','Maisie','Wong','Risa','dignissim.tempor@Aliquamtincidunt.com','076 8172 4069');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('4E9168FC-5CB7-F2D7-485D-E587230CEC60','Christine','Sanford','Keaton','mi.Aliquam.gravida@acipsum.org','0387 013 6742');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('59711F02-AF11-BFC6-0EDD-45D5F2ACF098','Josiah','Greer','Travis','elit@Etiam.ca','0800 1111');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('1493596C-1BBC-EA79-1D58-03C5FB12744B','Ronan','Farley','Hermione','varius@sapiengravidanon.org','(01411) 74214');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('86AFEDA5-457D-5FF4-3661-BAEB19611B1B','Kellie','Ellis','Ingrid','cursus.luctus@purus.org','0851 120 7126');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('F4CC22E2-BCC2-9028-9419-FD846062480B','Nora','Goodwin','Ora','scelerisque@Nullam.co.uk','070 7424 7008');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('C8165AED-388E-9010-9C16-5E36867808A4','Phoebe','Gutierrez','Urielle','Ut.tincidunt@musProin.edu','0391 450 3890');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('83AC3CF3-E233-EC36-B67F-2EE870F44F3C','Jane','Carroll','Nero','nec.mauris.blandit@nisi.com','0800 707 3609');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('8B4ADA67-F831-045D-BBE8-A252DBDFAAC9','Knox','Bolton','Zenaida','consectetuer.cursus.et@turpis.edu','0500 063572');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('A1EA1BA2-DE7A-D97F-47BE-904B0A3A9C85','Whilemina','Brewer','Virginia','eleifend.nec@PraesentluctusCurabitur.com','07624 505173');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('F60F4D74-9190-BA75-A6AD-5EDE01A6EC9B','Gillian','Hurst','Lana','Duis@nuncsedlibero.ca','0915 544 4462');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('1FA9B7B2-FF6F-F0AF-E412-03D89BF3D5FE','Macey','Burgess','Blossom','arcu.Vestibulum.ante@pede.ca','(012807) 72513');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('756A748A-89D4-D520-C1AF-9DDF4C4A21F6','Salvador','Stevenson','Adrian','Aenean.euismod@magnased.edu','(01747) 504843');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('6971F4EC-A059-091B-3F6D-46500AC5112D','Allen','Meadows','Sade','enim.nisl.elementum@cursuseteros.edu','07478 134651');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('5A1403E5-1851-6F9A-1878-72381C62859A','Ezra','Barton','Dorothy','hendrerit.Donec@inlobortistellus.co.uk','055 7698 6287');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('F2D878BA-35E9-F127-DAEB-8A4593035522','Sydney','Ruiz','Ingrid','elit.dictum.eu@ultricesposuerecubilia.ca','076 4779 6400');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('89CDCA49-CBD3-3C34-7522-C268B58285EC','Walter','Maddox','Stephanie','dignissim.magna.a@musAenean.co.uk','070 2355 8562');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('70EBC331-19B8-FA87-66FC-CE87A05A13A8','Chloe','Joyce','Eliana','dui.nec.tempus@arcuCurabiturut.net','056 5603 2973');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('26C9759A-106B-9B16-0DB4-C10A865EB355','Conan','Duffy','Jakeem','Donec.tempus@tristique.org','(01487) 77025');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('1E37A2AF-D726-6AAC-6ACC-A1804A343BD9','Lesley','Leon','Martha','Cras.vulputate.velit@Donec.ca','070 7887 3992');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('A18889F4-7393-2673-B421-683938317AA3','Maisie','Steele','Kyla','Vestibulum@justonecante.edu','(01823) 13687');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('DB8E7302-B6C6-951D-187D-225B575D9264','Nelle','Ingram','Dieter','augue@dapibusquamquis.org','056 8774 0436');
INSERT INTO "players" (players_id,forename,surname,nickname,email,tel_no) VALUES ('09F7CC96-5CCC-9893-67F1-2AA92C6A4307','Shea','Jarvis','Austin','nibh@acmetus.com','(027) 7843 1961');


DROP TABLE IF EXISTS "games" CASCADE;

CREATE TABLE "games" (
	"games_id" uuid NOT NULL,
	"winner_id" uuid NOT NULL,
	"winner_score" int4 NOT NULL DEFAULT 0,
	"loser_id" uuid NOT NULL,
	"loser_score" int4 NOT NULL DEFAULT 0,
	"started" timestamp with time zone NOT NULL DEFAULT NOW(),
	"finished" timestamp with time zone NOT NULL DEFAULT NOW(),
	CONSTRAINT "pk_games" PRIMARY KEY("games_id")
);

CREATE INDEX "idx_games_winner_id" ON "games" (
	"winner_id"
);


CREATE INDEX "idx_games_loser_id" ON "games" (
	"loser_id"
);


CREATE TRIGGER "trig_games_change" AFTER INSERT OR UPDATE OR DELETE
	ON "games" FOR EACH ROW
	EXECUTE PROCEDURE "trig_stats_update"();


COMMENT ON TABLE "games" IS 'Results of all the scrabble games.';

COMMENT ON COLUMN "games"."winner_id" IS 'Winner uuid.';

COMMENT ON COLUMN "games"."winner_score" IS 'Winner''s score.';

COMMENT ON COLUMN "games"."loser_id" IS 'Loser uuid.';

COMMENT ON COLUMN "games"."loser_score" IS 'Loser''s score.';

COMMENT ON COLUMN "games"."started" IS 'When the game was started.';

COMMENT ON COLUMN "games"."finished" IS 'When the game finished.';

DROP TABLE IF EXISTS "stats" CASCADE;

CREATE TABLE "stats" (
	"stats_id" uuid NOT NULL DEFAULT gen_random_uuid(),
	"games" int4 NOT NULL DEFAULT 0,
	"wins" int4 NOT NULL DEFAULT 0,
	"losses" int4 NOT NULL DEFAULT 0,
	"avg_score" int4 NOT NULL DEFAULT 0,
	"max_score" int4 NOT NULL DEFAULT 0,
	"updated" timestamp with time zone NOT NULL DEFAULT NOW(),
	CONSTRAINT "pk_stats" PRIMARY KEY("stats_id")
);


ALTER TABLE "players" ADD CONSTRAINT "fk_players_to_stats" FOREIGN KEY ("stats_id")
	REFERENCES "stats"("stats_id")
	MATCH SIMPLE
	ON DELETE SET NULL
	ON UPDATE CASCADE
	NOT DEFERRABLE;

ALTER TABLE "games" ADD CONSTRAINT "fk_games_winner_to_players" FOREIGN KEY ("winner_id")
	REFERENCES "players"("players_id")
	MATCH SIMPLE
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
	NOT DEFERRABLE;

ALTER TABLE "games" ADD CONSTRAINT "fk_games_loser_to_players" FOREIGN KEY ("loser_id")
	REFERENCES "players"("players_id")
	MATCH SIMPLE
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
	NOT DEFERRABLE;


CREATE OR REPLACE VIEW "vw_stats" AS
	SELECT
  players_id,
  COUNT(*) AS games,
  SUM(CASE WHEN players_id=winner_id THEN 1 ELSE 0 END) AS wins,
  SUM(CASE WHEN players_id=loser_id THEN 1 ELSE 0 END) AS losses,
  AVG(CASE WHEN players_id=winner_id THEN winner_score WHEN players_id=loser_id THEN loser_score ELSE 0 END)::INTEGER AS avg_score,
  MAX(CASE WHEN players_id=winner_id THEN winner_score WHEN players_id=loser_id THEN loser_score ELSE 0 END)::INTEGER AS max_score
FROM
  players p
JOIN
  games g ON p.players_id=g.winner_id OR p.players_id=g.loser_id
GROUP BY
  1;

COMMENT ON VIEW "vw_stats" IS 'Used to help build the stats table.';

-- 1 down
-- DROP TABLE IF EXISTS "games" CASCADE;
-- DROP TABLE IF EXISTS "players" CASCADE;
-- DROP TABLE IF EXISTS "stats" CASCADE;
-- DROP VIEW IF EXISTS "vw_stats" CASCADE;
