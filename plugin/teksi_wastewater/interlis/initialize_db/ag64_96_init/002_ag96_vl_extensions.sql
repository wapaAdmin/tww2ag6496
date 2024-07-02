------------------
-- Organisation extension
------------------

INSERT INTO tww_od.organisation(
	obj_id, identifier, remark, uid, last_modification, fk_dataowner, fk_provider,organisation_type,status)
	VALUES 
	('ch113jqg00000000',  'AfU Aargau',  'bei Import AG-64/AG-96 generiert','CHE114809310', now(), 'ch113jqg00000000','ch113jqg00000000',8605,9047),
	('ch20p3q400000154', 'Gemeinde Wettingen', NULL, 'CHE115075438', '2016-02-05', 'ch113jqg00000000', 'ch113jqg00000000',8604,9047),
	('ch20p3q400000315', 'Avia Tanklager Beteiligungs AG, Mellingen', NULL, 'CHE102501414', '2017-09-29', 'ch113jqg00000000', 'ch113jqg00000000',8606,9047),
	('ch20p3q400000333', 'Kernkraftwerk Leibstadt AG', 'für_AraKKW_Leibstadt', 'CHE101719293', '2017-10-30', 'ch113jqg00000000', 'ch113jqg00000000',8606,9047),
	('ch20p3q400000335', 'Axpo Power AG', 'u.a. für Ara Beznau', 'CHE105781196', '2017-10-30', 'ch113jqg00000000', 'ch113jqg00000000',8606,9047),
	('ch20p3q400000343', 'Recyclingcenter Freiamt AG', NULL, 'CHE102501414', '2018-11-28', 'ch113jqg00000000', 'ch113jqg00000000',8606,9047),
	('ch20p3q400000348', 'PDAG-Fonds-Verein', 'Areal Königsfelden', 'CHE116398921', '2020-07-02', 'ch113jqg00000000', 'ch113jqg00000000',8606,9047);

------------------
-- value list extensions
------------------


-- Einzugsgebiet_Entwaesserungssystem
INSERT INTO tww_vl.catchment_area_drainage_system_planned (code,vsacode,value_de,value_en,active) VALUES
(1999994,5193,'TeilTrennsystem_mit_Dachwasserversickerung_oder_Ableitung_in_Gewaesser','part_sep_sys_infil_or_water_body',true),
(1999995,5193,'TeilTrennsystem_mit_Dachwasserableitung_in_Gewaesser','part_sep_sys_in_water_body',true),
(1999996,5193,'TeilTrennsystem_mit_Dachwasserversickerung','part_sep_sys_infiltration',true)
ON CONFLICT DO NOTHING;
INSERT INTO tww_vl.catchment_area_drainage_system_current (code,vsacode,value_de,value_en,active) VALUES
(1999997,5188,'TeilTrennsystem_mit_Dachwasserversickerung_oder_Ableitung_in_Gewaesser','part_sep_sys_infil_or_water_body',true),
(1999998,5188,'TeilTrennsystem_mit_Dachwasserableitung_in_Gewaesser','part_sep_sys_in_water_body',true),
(1999999,5188,'TeilTrennsystem_mit_Dachwasserversickerung','part_sep_sys_infiltration',true)
ON CONFLICT DO NOTHING;

-- Kanal_Nutzungsart	
INSERT INTO tww_vl.channel_usage_planned (code,vsacode,value_de,value_en,active) VALUES
(1999992,4521,'Platzwasser','square_water',true) ON CONFLICT DO NOTHING;
INSERT INTO tww_vl.channel_usage_current (code,vsacode,value_de,value_en,active) VALUES
(1999993,4520,'Platzwasser','square_water',true) ON CONFLICT DO NOTHING;
INSERT INTO tww_vl.channel_usage_planned (code,vsacode,value_de,value_en,active) VALUES
(1999990,4521,'Strassenwasser','street_water',true) ON CONFLICT DO NOTHING;
INSERT INTO tww_vl.channel_usage_current (code,vsacode,value_de,value_en,active) VALUES
(1999989,4520,'Strassenwasser','street_water',true) ON CONFLICT DO NOTHING;
--Kanal_FunktionHierarchisch
INSERT INTO tww_vl.channel_function_hierarchic (code,vsacode,value_de,value_en,active) VALUES
(1999991,5071,'PAA.Arealentwaesserung','pwwf.site_drainage',true)ON CONFLICT DO NOTHING;

-- Massnahme
INSERT INTO tww_vl.measure_category (code,vsacode,value_de,value_en,active) VALUES
(1999988,8639,'Bachrenaturierung','creek_renaturalisation',true), -- 8639 = Massnahme_im_Gewaesser 
(1999987,8639,'Bachsanierung','creek_renovation',true), -- 8639 = Massnahme_im_Gewaesser 
(1999986,8707,'Einstellung_anpassen_hydraulisch','alter_hydr_settings',true), -- 8707 = Sonderbauwerk_Anpassung 
(1999985,4660,'GEP_Vorbereitungsarbeiten','GEP_preparations',true) , -- 4660 = GEP_Bearbeitung 
(1999984,8706,'Leitungsersatz_diverse_Gruende','reach_replacement_other',true) , -- 8706 = Erhaltung_Erneuerung 
(1999983,8706,'Leitungsersatz_hydraulisch','reach_replacement_hydraulic',true) , -- 8706 = Erhaltung_Erneuerung 
(1999982,8706,'Leitungsersatz_Zustand','reach_replacement_condition',true) , -- 8706 = Erhaltung_Erneuerung 
(1999981,8648,'Reinigung','reach_replacement_condition',true) , -- 8648 = Erhaltung_Reinigung 
(1999980,8646,'Renovierung','reach_replacement_condition',true) , -- 8646 = Erhaltung_Renovierung_Reparatur 
(1999979,8646,'Reparatur','reach_replacement_condition',true) , -- 8646 = Erhaltung_Renovierung_Reparatur 
(1999978,8649,'Retention','reach_replacement_condition',true) , -- 8649 = Abflussvermeidung_Retention_Versickerung 
(1999977,8705,'Sonderbauwerk.Neubau','reach_replacement_condition',true) , -- 8705 = Sonderbauwerk_Neubau 
(1999976,8707,'Sonderbauwerk.Aus_Umbau','reach_replacement_condition',true) , -- 8707 = Sonderbauwerk_Anpassung 
(1999975,8707,'Sonderbauwerk.Anpassung_hydraulisch','reach_replacement_condition',true) , -- 8707 = Sonderbauwerk_Anpassung 
(1999974,4654,'Sonderbauwerk.Rueckbau','reach_replacement_condition',true) , -- 4654 = Aufhebung 
(1999973,4662,'Untersuchung.andere','reach_replacement_condition',true) , -- 4662 = Kontrolle_und_Ueberwachung 
(1999972,4662,'Untersuchung.Begehung','reach_replacement_condition',true) , -- 4662 = Kontrolle_und_Ueberwachung 
(1999971,4662,'Untersuchung.Dichtheitsprüfung','reach_replacement_condition',true) , -- 4662 = Kontrolle_und_Ueberwachung 
(1999970,4662,'Untersuchung.Kanalfernsehen','reach_replacement_condition',true) , -- 4662 = Kontrolle_und_Ueberwachung 
(1999969,4662,'Untersuchung.unbekannt','reach_replacement_condition',true) -- 4662 = Kontrolle_und_Ueberwachung 
ON CONFLICT DO NOTHING;



UPDATE tww_vl.measure_category SET active = FALSE where code = ANY( ARRAY[
9144 	-- ALR
, 8706 	-- Erhaltung_Erneuerung
, 8648 	-- Erhaltung_Reinigung
, 8646	-- Erhaltung_Renovierung_Reparatur
, 8647	-- Erhaltung_unbekannt
, 4662  -- Kontrolle_und_Ueberwachung
, 8639  -- Massnahme_im_Gewaesser 
, 8707  -- Sonderbauwerk_Anpassung 
, 8705  -- Sonderbauwerk_Neubau 
]);


INSERT INTO tww_vl.manhole_function (code,vsacode,value_de,value_en,active) VALUES
(1999968,2742,'Schlammfang','sludge_trap',true)		-- Schlammsammler
ON CONFLICT DO NOTHING;

UPDATE tww_vl.manhole_function SET active = false WHERE code = ANY(Array[
  8828	-- Entwaesserungsrinne_mit_Schlammsack
, 8601	-- Fettabscheider

]);

UPDATE tww_vl.special_structure_function SET active = false WHERE code = ANY(Array[
  8600 	-- Fettabscheider
, 8657	-- Havariebecken
]);

INSERT INTO tww_vl.special_structure_function (code,vsacode,value_de,value_en,active) VALUES
(1999967,8702,'Oelrueckhaltebecken','oil_retention_basin',true)  -- Mappt auf Behandlungsanlage

ON CONFLICT DO NOTHING;


INSERT INTO tww_vl.infiltration_installation_kind (code,vsacode,value_de,value_en,active) VALUES
(1999966,3087,'andere','other',true),  -- Mappt auf unbekannt
(1999965,3282,'Retentionsfilterbecken','manhole',true)  -- Mappt auf andere_mit_Bodenpassage
ON CONFLICT DO NOTHING;




INSERT INTO tww_vl.building_group_ag96_disposal_type (code,vsacode,value_de,value_en,active) VALUES
(1999964,1999964,'Ableitung_Verwertung','drainage',true),  -- kein VSA mapping
(1999963,1999963,'Klaereinrichtung_Speicherung','clearing_storing',true),  -- kein VSA mapping
(1999962,1999962,'keinBedarf','noDemand',true),  -- kein VSA mapping
(1999961,1999961,'pendent','pending',true)  -- kein VSA mapping
ON CONFLICT DO NOTHING;

ALTER TABLE tww_od.building_group ADD CONSTRAINT fkey_vl_building_group_ag96_disposal_wastewater FOREIGN KEY (ag96_disposal_wastewater) REFERENCES tww_vl.building_group_ag96_disposal_type MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT; 
ALTER TABLE tww_od.building_group ADD CONSTRAINT fkey_vl_building_group_ag96_disposal_industrial_wastewater FOREIGN KEY (ag96_disposal_industrial_wastewater) REFERENCES tww_vl.building_group_ag96_disposal_type MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT; 
ALTER TABLE tww_od.building_group ADD CONSTRAINT fkey_vl_building_group_ag96_disposal_square_water FOREIGN KEY (ag96_disposal_square_water) REFERENCES tww_vl.building_group_ag96_disposal_type MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT; 
ALTER TABLE tww_od.building_group ADD CONSTRAINT fkey_vl_building_group_ag96_disposal_roof_water FOREIGN KEY (ag96_disposal_roof_water) REFERENCES tww_vl.building_group_ag96_disposal_type MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT; 

INSERT INTO tww_vl.organisation_organisation_type (code,vsacode,value_de,active) VALUES
(1999952,8605,'Amt',true)  -- VSA mapping auf Kanton
ON CONFLICT DO NOTHING;

INSERT INTO tww_vl.wastewater_node_ag96_is_gateway (code,vsacode,value_de,active) VALUES
(1999951,1999951,'Schnittstelle',true),  
(1999950,1999950,'keine_Schnittstelle',true),  
(1999949,1999949,'unbekannt',true)
ON CONFLICT DO NOTHING;
ALTER TABLE tww_od.wastewater_node ADD CONSTRAINT fkey_vl_wastewater_node_ag96_is_gateway FOREIGN KEY (ag96_is_gateway) REFERENCES tww_vl.wastewater_node_ag96_is_gateway MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT; 

INSERT INTO tww_vl.wastewater_node_ag64_function (code,vsacode,value_de,active) VALUES
(1999948,1999948,'Anschluss',true)
ON CONFLICT DO NOTHING;
ALTER TABLE tww_od.wastewater_node ADD CONSTRAINT fkey_vl_wastewater_node_ag64_function FOREIGN KEY (ag64_function) REFERENCES tww_vl.wastewater_node_ag64_function MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT; 

INSERT INTO tww_vl.pipe_profile_profile_type (code,vsacode,value_de,value_en,active) VALUES
(1999947,3357,'andere','other',true) -- 3357 = unbekannt 
ON CONFLICT DO NOTHING;


-- Versickerungsbereich
INSERT INTO tww_vl.infiltration_zone_infiltration_capacity (code,vsacode,value_de,value_en,active) VALUES
(1999946,371,'gut.Anlagenwahl_nicht_eingeschraenkt','good.free_choice',true), -- 371 = gut 
(1999945,371,'gut.Anlagenwahl_eingeschraenkt','good.restricted_choice',true), -- 371 = gut 
(1999944,371,'mittel.Anlagenwahl_nicht_eingeschraenkt','medium.free_choice',true), -- 372 = maessig  
(1999943,371,'mittel.Anlagenwahl_eingeschraenkt','medium.restricted_choice',true)  -- 372 = maessig 
ON CONFLICT DO NOTHING;

UPDATE tww_vl.infiltration_zone_infiltration_capacity SET active = FALSE where code = ANY( ARRAY[
371 	-- gut
, 372 	-- maessig
]);


------------------------
-- Backwards Matching --
------------------------

INSERT INTO tww_vl.infiltration_installation_kind_bwrel_agxx (code,value_agxx) VALUES
(3283,'Versickerungsstrang'),  
(3284,'Versickerungsschacht_Strang')
ON CONFLICT DO NOTHING;  

INSERT INTO tww_vl.special_structure_function_bwrel_agxx (code,value_agxx) VALUES
(8702,'Strassenwasserbehandlungsanlage'),  
(8739,'Kontrollschacht'),  
(9089,'Vorbehandlung')
ON CONFLICT DO NOTHING; 

INSERT INTO tww_vl.manhole_function_bwrel_agxx (code,value_agxx) VALUES
(8736,'Kontrollschacht'),  
(8703,'Vorbehandlung')
ON CONFLICT DO NOTHING;

INSERT INTO tww_vl.channel_usage_current_bwrel_agxx (code,value_agxx) VALUES
(4522,'Mischwasser'),  
(4514,'Fremdwasser'),
(9023,'Sauberwasser'),
(4518,'Gewaesser'),
(4516,'Entlastetes_Mischwasser'),
(4526,'Schmutzwasser')
ON CONFLICT DO NOTHING;

INSERT INTO tww_vl.channel_usage_planned_bwrel_agxx (code,value_agxx) VALUES
(4523,'Mischwasser'),  
(4515,'Fremdwasser'),
(9022,'Sauberwasser'),
(4519,'Gewaesser'),
(4517,'Entlastetes_Mischwasser'),
(4527,'Schmutzwasser')
ON CONFLICT DO NOTHING;

INSERT INTO tww_vl.building_group_function_bwrel_agxx (code,value_agxx) VALUES
(4823,'andere'),  
(4820,'Ferienhaus'),
(4821,'Gewerbegebiet'),
(4822,'Landwirtschaftsgebiet'),
(4818,'andere'),
(4819,'Wohnhaus')
ON CONFLICT DO NOTHING;

INSERT INTO tww_vl.infiltration_zone_infiltration_capacity_bwrel_agxx (code,value_agxx) VALUES
(371,'gut.Anlagenwahl_nicht_eingeschraenkt'),  
(372,'mittel.Anlagenwahl_nicht_eingeschraenkt')
ON CONFLICT DO NOTHING;

INSERT INTO tww_vl.manhole_function_bwrel_agxx (code,value_agxx) VALUES
(8828,'Entwaesserungsrinne'),  
(8601,'Schwimmstoffabscheider')
ON CONFLICT DO NOTHING;

INSERT INTO tww_vl.special_structure_function_bwrel_agxx (code,value_agxx) VALUES
(8600,'Schwimmstoffabscheider'),  
(8657,'andere')
ON CONFLICT DO NOTHING;


INSERT INTO tww_vl.measure_category_bwrel_agxx (code,value_agxx) VALUES
(9144,'andere'),
(8706,'andere'),
(8648,'Reinigung'),
(8646,'Renovierung'),
(8647,'andere'),
(4662,'Untersuchung.unbekannt'),
(8639,'andere'),
(8707,'Sonderbauwerk.Anpassung_hydraulisch'),
(8705,'Sonderbauwerk.Neubau')
ON CONFLICT DO NOTHING;

