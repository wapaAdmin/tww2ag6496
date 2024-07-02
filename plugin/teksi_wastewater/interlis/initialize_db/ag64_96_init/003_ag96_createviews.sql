----------------
-- organisation
----------------
DROP VIEW IF EXISTS {ext_schema}.organisation;
CREATE VIEW {ext_schema}.organisation
AS
SELECT concat_ws(''::text, 'ch113jqg0000', "right"(org.obj_id::text, 8)) AS obj_id,
    regexp_replace(org.uid, '(^.{3})(.{3})(.{3})'::text, '\1-\2.\3.'::text) AS uid,
    org.identifier AS bezeichnung,
    org.identifier_short AS kurzbezeichnung,
    'AfU Aargau'::text AS datenbewirtschafter_kt,
    ot.value_de AS organisationtyp,
    org.last_modification AS letzte_aenderung,
    org.remark AS bemerkung
   FROM tww_od.organisation org
     LEFT JOIN tww_vl.organisation_organisation_type ot ON ot.code = org.organisation_type
  WHERE org.tww_active;

------------------
-- GEPKnoten
------------------

-- Mapping:
/*
FunktionBauwerkAG =   (                     
	  abflussloseGrube, 							--> special_structure
	  Absturzbauwerk,  								--> detailgeometrie
      Abwasserfaulraum,              				--> special_structure                                                                            
	  andere, 										--> detailgeometrie
	  Be_Entlueftung,  								--> detailgeometrie
	  Dachwasserschacht,							--> manhole
	  Duekerkammer, 								--> special_structure 
	  Duekeroberhaupt, 								--> special_structure
	  Einlaufschacht,  								--> manhole
	  Einleitstelle_gewaesserrelevant,           	--> discharge_point
	  Einleitstelle_nicht_gewaesserrelevant,     	--> discharge_point
	  Entwaesserungsrinne, 							--> manhole 
      Faulgrube,                         			--> special_structure                                                                                   
	  Gelaendemulde,                   				--> special_structure                   
	  Geleiseschacht,								--> manhole
	  Geschiebefang,                   				--> special_structure                                  
	  Guellegrube,                    				--> special_structure                                
      Klaergrube,                      				--> special_structure                             
      Kontrollschacht,  							--> detailgeometrie
	  Leitungsknoten,                               --> wastewater_node
	  Messstelle,                                   --> detailgeometrie, measurement
	  Oelabscheider,       							--> detailgeometrie                          
	  Pumpwerk,                   					--> detailgeometrie              
	  Regenbecken_Durchlaufbecken,               	--> special_structure                 
	  Regenbecken_Fangbecken,                      	--> special_structure            
	  Regenbecken_Fangkanal,                      	--> special_structure           
	  Regenbecken_Regenklaerbecken,               	--> special_structure             
	  Regenbecken_Regenrueckhaltebecken,           	--> special_structure           
	  Regenbecken_Regenrueckhaltekanal,            	--> special_structure           
	  Regenbecken_Stauraumkanal,                   	--> special_structure            
	  Regenbecken_Verbundbecken,                   	--> special_structure                
	  Regenueberlauf,        						--> detailgeometrie                         
	  Schlammsammler,       						--> manhole                     
	  Schwimmstoffabscheider,    					--> detailgeometrie  
	  seitlicherZugang,        		             	--> special_structure  
	  Spuelschacht,    								--> detailgeometrie 
	  Trennbauwerk,         						--> detailgeometrie                        
	  unbekannt, 									--> detailgeometrie  
	  Versickerungsanlage (              		 	--> infiltration_installation             
	    Versickerungsbecken,                     
		Kieskoerper,                              
		Versickerungsschacht,                     
		Versickerungsstrang,                      
		Versickerungsschacht_Strang,              
		Retentionsfilterbecken,                   
		andere,
		unbekannt),
	  Wirbelfallschacht,    		             	--> special_structure  
	  Abwasserreinigungsanlage,   		           	--> wastewater_node, wwtp                                    
	  Anschluss,                   		           	--> wastewater_node, building                   
	  Bodenablauf,                                	--> manhole   
	  Oelrueckhaltebecken,                         	--> special_structure                   
	  Regenwasserrechen,                          	--> special_structure.other                     
	  Regenwassersieb,                             	--> special_structure.other                        
	  Rohrbruecke,                                 	--> special_structure.other                        
	  Schlammfang,                         			--> manhole     
	  Strassenwasserbehandlungsanlage,             	--> special_structure   
	  Vorbehandlung              					--> detailgeometrie 
	);


*/


DROP VIEW IF EXISTS {ext_schema}.gepknoten;
CREATE VIEW {ext_schema}.gepknoten
AS
 SELECT wn.obj_id,
    wn.wwtp_number AS ara_nr,
    COALESCE(ws.year_of_construction::integer, unc.baujahr, 1800) AS baujahr,
    COALESCE(sc.value_de, unc.baulicherzustand) AS baulicherzustand,
        CASE
            WHEN st.value_de::text = 'in_Betrieb'::text THEN 'in_Betrieb.in_Betrieb'::character varying
            ELSE COALESCE(st.value_de, unc.bauwerkstatus, 'unbekannt'::character varying)
        END AS bauwerkstatus,
    ne.ag64_remark AS bemerkung_wi,
    ne.identifier AS bezeichnung,
    COALESCE(main_co.level, unc.deckelkote) AS deckelkote,
    COALESCE(st_force2d(main_ws.detail_geometry3d_geometry), unc.detailgeometrie2d) AS detailgeometrie,
    COALESCE(fi.value_de, unc.finanzierung) AS finanzierung,
    COALESCE(
        CASE
            WHEN meas_pt.obj_id IS NOT NULL AND (ss_fu.value_de::text !~~ ANY (ARRAY['Regenbecken%'::text, 'Regenueberlauf'::text, 'Pumpwerk'::text, 'Dueker%'::text, 'Versickerungsanlage%'::text])) THEN 'Messstelle'::text
            WHEN wn.ag64_function IS NOT NULL THEN 'Anschluss'::text
            WHEN wwtp.obj_id IS NOT NULL THEN 'Abwasserreinigungsanlage'::text
            ELSE NULL::text
        END, ma_fu_rev.value_agxx, ma_fu.value_de::text, ss_fu_rev.value_agxx, ss_fu.value_de::text, 'Einleitstelle_'::text || dp_rel.value_de::text, 'Versickerungsanlage.'::text || ii_ki_rev.value_agxx, 'Versickerungsanlage.'::text || ii_ki.value_de::text, 'Leitungsknoten'::text) AS funktionag,
    COALESCE("left"(fhi.value_de::text, 3), unc.funktionhierarchisch::text, 'SAA'::text) AS funktionhierarchisch,
    COALESCE(isgate.value_de, 'unbekannt'::character varying) AS istschnittstelle,
    COALESCE(ws.status_survey_year::integer, unc.jahr_zustandserhebung, 1800) AS jahr_zustandserhebung,
    st_force2d(COALESCE(main_co.situation3d_geometry, wn.situation3d_geometry)) AS lage,
    ne.ag64_last_modification AS letzte_aenderung_wi,
    COALESCE(co_pa.value_de, unc.lagegenauigkeit) AS lagegenauigkeit,
    wn.backflow_level_current AS maxrueckstauhoehe,
    COALESCE(rn.value_de, unc.sanierungsbedarf) AS sanierungsbedarf,
    wn.bottom_level AS sohlenkote,
    COALESCE(ac.value_de, unc.zugaenglichkeit) AS zugaenglichkeit,
    concat_ws(''::text, 'ch113jqg0000', "right"(COALESCE(ws.fk_operator, unc.betreiber, '00000107'::character varying)::text, 8)) AS betreiber,
    concat_ws(''::text, 'ch113jqg0000', "right"(COALESCE(ne.ag64_fk_provider, '00000107'::character varying)::text, 8)) AS datenbewirtschafter_wi,
    concat_ws(''::text, 'ch113jqg0000', "right"(COALESCE(ws.fk_owner, unc.eigentuemer, '00000107'::character varying)::text, 8)) AS eigentuemer,
    COALESCE(ws.ag96_fk_measure, unc.gepmassnahmeref) AS gepmassnahmeref,
    concat_ws(''::text, 'ch113jqg0000', "right"(COALESCE(ne.ag96_fk_provider, '00000107'::character varying)::text, 8)) AS datenbewirtschafter_gep,
    ne.ag96_remark AS bemerkung_gep,
    COALESCE(ne.ag96_last_modification::timestamp with time zone, to_timestamp('1800-01-01'::text, 'YYYY-MM-DD'::text)) AS letzte_aenderung_gep
   FROM tww_od.wastewater_node wn
     LEFT JOIN tww_od.wastewater_networkelement ne ON wn.obj_id::text = ne.obj_id::text
     LEFT JOIN tww_od.wastewater_structure ws ON ne.fk_wastewater_structure::text = ws.obj_id::text
     LEFT JOIN tww_od.wastewater_structure main_ws ON wn.obj_id::text = main_ws.fk_main_wastewater_node::text
     LEFT JOIN tww_od.measuring_point meas_pt ON main_ws.obj_id::text = meas_pt.fk_wastewater_structure::text
     LEFT JOIN tww_od.connection_object conn_obj ON ne.obj_id::text = conn_obj.fk_wastewater_networkelement::text
     LEFT JOIN tww_od.building build ON build.obj_id::text = conn_obj.obj_id::text
     LEFT JOIN tww_od.wwtp_structure wwtp ON main_ws.obj_id::text = wwtp.obj_id::text
     LEFT JOIN tww_vl.wastewater_node_ag96_is_gateway isgate ON wn.ag96_is_gateway = isgate.code
     LEFT JOIN tww_od.agxx_unconnected_node_bwrel unc ON unc.obj_id::text = wn.obj_id::text
     LEFT JOIN tww_vl.wastewater_structure_status st ON st.code = ws.status
     LEFT JOIN tww_od.manhole ma ON main_ws.obj_id::text = ma.obj_id::text
     LEFT JOIN tww_vl.manhole_function ma_fu ON ma_fu.code = ma.function
     LEFT JOIN tww_vl.manhole_function_bwrel_agxx ma_fu_rev ON ma_fu_rev.code = ma.function
     LEFT JOIN tww_od.special_structure ss ON main_ws.obj_id::text = ss.obj_id::text
     LEFT JOIN tww_vl.special_structure_function ss_fu ON ss_fu.code = ss.function
     LEFT JOIN tww_vl.special_structure_function_bwrel_agxx ss_fu_rev ON ss_fu_rev.code = ss.function
     LEFT JOIN tww_od.infiltration_installation ii ON main_ws.obj_id::text = ii.obj_id::text
     LEFT JOIN tww_vl.infiltration_installation_kind ii_ki ON ii_ki.code = ii.kind
     LEFT JOIN tww_vl.infiltration_installation_kind_bwrel_agxx ii_ki_rev ON ii_ki_rev.code = ii.kind
     LEFT JOIN tww_od.discharge_point dp ON main_ws.obj_id::text = dp.obj_id::text
     LEFT JOIN tww_vl.discharge_point_relevance dp_rel ON dp_rel.code = dp.relevance
     LEFT JOIN tww_vl.wastewater_structure_structure_condition sc ON sc.code = ws.structure_condition
     LEFT JOIN tww_vl.wastewater_structure_renovation_necessity rn ON rn.code = ws.renovation_necessity
     LEFT JOIN tww_vl.wastewater_structure_financing fi ON fi.code = ws.financing
     LEFT JOIN tww_vl.channel_function_hierarchic fhi ON fhi.code = wn._function_hierarchic
     LEFT JOIN tww_od.cover main_co ON main_co.obj_id::text = ws.fk_main_cover::text
     LEFT JOIN tww_vl.cover_positional_accuracy co_pa ON co_pa.code = main_co.positional_accuracy
     LEFT JOIN tww_vl.wastewater_structure_accessibility ac ON ac.code = ws.accessibility;

------------------
-- GEPHaltung
------------------

DROP VIEW IF EXISTS {ext_schema}.gephaltung;
CREATE OR REPLACE VIEW {ext_schema}.gephaltung
AS

SELECT
	  re.obj_id AS obj_id
	, ws.year_of_construction AS baujahr	  
	, sc.value_de AS baulicherzustand  
	, CASE WHEN st.value_de = 'in_Betrieb' THEN 'in_Betrieb.in_Betrieb' ELSE st.value_de END AS bauwerkstatus
	, ne.ag64_remark AS bemerkung_wi
	, ne.identifier AS bezeichnung
	, fi.value_de AS finanzierung
	, fhi.value_de AS funktionhierarchisch
	, fhy.value_de AS funktionhydraulisch
	, ea_to.value_de AS hoehengenauigkeit_nach
	, ea_from.value_de AS hoehengenauigkeit_von
	, re.hydraulic_load_current AS hydraulischebelastung
	, ws.status_survey_year AS jahr_zustandserhebung
	, NULLIF(rp_from.level,0) AS kote_beginn
	, NULLIF(rp_to.level,0)AS kote_ende
	, ne.ag64_last_modification AS letzte_aenderung_wi
	, re.ag96_clear_width_planned AS lichte_breite_geplant
	, CASE
            WHEN pp.height_width_ratio IS NOT NULL THEN round(re.clear_height::numeric / pp.height_width_ratio)::smallint::integer
            ELSE re.clear_height
      END AS lichte_breite_ist
	, re.ag96_clear_height_planned AS lichte_hoehe_geplant
	, re.clear_height AS lichte_hoehe_ist
	, re.length_effective AS laengeeffektiv
	, mat.value_de AS material
	, ppt.value_de AS profiltyp
	, coalesce (up_rev.value_agxx,up.value_de) AS nutzungsartag_geplant
	, coalesce (uc_rev.value_agxx, uc.value_de) AS nutzungsartag_ist
	, relkind.value_de AS reliner_art
	, relcons.value_de AS reliner_bautechnik
	, relmat.value_de AS reliner_material
	, re.reliner_nominal_size  AS reliner_nennweite
	, rn.value_de  AS sanierungsbedarf
	, ST_Force2D(re.progression3d_geometry) AS verlauf
	, ws.rv_base_year AS wbw_basisjahr
	, ws.replacement_value AS wiederbeschaffungswert
	, concat_ws('','ch113jqg0000',right(ws.fk_operator,8)) AS betreiber
	, concat_ws('','ch113jqg0000',right(ne.ag64_fk_provider,8)) AS datenbewirtschafter_wi
	, concat_ws('','ch113jqg0000',right(ws.fk_owner,8)) AS eigentuemer
	, rp_to.fk_wastewater_networkelement  AS endknoten
	, rp_from.fk_wastewater_networkelement AS startknoten
	, ws.ag96_fk_measure AS gepmassnahmeref
	, concat_ws('','ch113jqg0000',right(ne.ag96_fk_provider,8)) AS datenbewirtschafter_gep
	, ne.ag96_remark as bemerkung_gep
	, ne.ag96_last_modification as letzte_aenderung_gep
FROM tww_od.reach re
	LEFT JOIN tww_od.wastewater_networkelement ne ON ne.obj_id::text = re.obj_id::text
    LEFT JOIN tww_od.reach_point rp_from ON rp_from.obj_id::text = re.fk_reach_point_from::text
    LEFT JOIN tww_od.reach_point rp_to ON rp_to.obj_id::text = re.fk_reach_point_to::text
    LEFT JOIN tww_od.wastewater_structure ws ON ne.fk_wastewater_structure::text = ws.obj_id::text
    LEFT JOIN tww_od.channel ch ON ch.obj_id::text = ws.obj_id::text
    LEFT JOIN tww_od.pipe_profile pp ON re.fk_pipe_profile::text = pp.obj_id::text

	LEFT JOIN tww_vl.reach_reliner_material relmat ON relmat.code=re.reliner_material
	LEFT JOIN tww_vl.reach_relining_construction relcons ON relcons.code=re.relining_construction
	LEFT JOIN tww_vl.reach_relining_kind relkind ON relkind.code=re.relining_kind
	LEFT JOIN tww_vl.reach_point_elevation_accuracy ea_from ON ea_from.code=rp_from.elevation_accuracy
	LEFT JOIN tww_vl.reach_point_elevation_accuracy ea_to ON ea_to.code=rp_to.elevation_accuracy
	LEFT JOIN tww_vl.wastewater_structure_financing fi on fi.code=ws.financing
	LEFT JOIN tww_vl.wastewater_structure_renovation_necessity rn ON rn.code=ws.renovation_necessity
	LEFT JOIN tww_vl.wastewater_structure_structure_condition sc on sc.code=ws.structure_condition

	LEFT JOIN tww_vl.channel_function_hierarchic fhi ON fhi.code=ch.function_hierarchic
	LEFT JOIN tww_vl.channel_function_hydraulic fhy ON fhy.code=ch.function_hydraulic
	LEFT JOIN tww_vl.reach_material mat ON mat.code=re.material
	LEFT JOIN tww_vl.pipe_profile_profile_type ppt ON ppt.code=pp.profile_type
	LEFT JOIN tww_vl.wastewater_structure_status st ON st.code=ws.status
	LEFT JOIN tww_vl.channel_usage_current uc ON uc.code=ch.usage_current
	LEFT JOIN tww_vl.channel_usage_current_bwrel_agxx uc_rev ON uc_rev.code=ch.usage_current
	LEFT JOIN tww_vl.channel_usage_planned up ON up.code=ch.usage_planned
	LEFT JOIN tww_vl.channel_usage_planned_bwrel_agxx up_rev ON up_rev.code=ch.usage_planned
;


------------------
-- GEPMassnahme
------------------
DROP VIEW IF EXISTS {ext_schema}.gepmassnahme;
CREATE VIEW {ext_schema}.gepmassnahme
AS
SELECT
	  msr.obj_id
	, msr.line_geometry AS ausdehnung
	, msr.description AS beschreibung
	, msr.identifier AS bezeichnung
	, msr.date_entry AS datum_eingang
	, msr.total_cost AS gesamtkosten
	, msr.intervention_demand AS handlungsbedarf
	, msr.year_implementation_effective AS jahr_umsetzung_effektiv
	, msr.year_implementation_planned AS jahr_umsetzung_planned
	, msr_ct.value_de AS kategorie
	, msr.perimeter_geometry AS perimeter
	, msr_pri.value_de AS prioritaetag
	, msr_st.value_de AS status
	, msr.symbolpos_geometry AS symbolpos
	, msr.link AS verweis
	, concat_ws('','ch113jqg0000',right(msr.fk_responsible_entity,8)) AS traegerschaft
	, concat_ws('','ch113jqg0000',right(msr.fk_responsible_start,8)) AS verantwortlich_ausloesung
	, concat_ws('','ch113jqg0000',right(msr.fk_provider,8)) AS datenbewirtschafter_gep
	, msr.remark as bemerkung_gep
	, msr.last_modification as letzte_aenderung_gep
FROM tww_od.measure msr
	LEFT JOIN tww_vl.measure_category msr_ct on msr_ct.code = msr.category
	LEFT JOIN tww_vl.measure_priority msr_pri on msr_pri.code = msr.priority
	LEFT JOIN tww_vl.measure_status msr_st on msr_st.code = msr.status
	;


------------------
-- Einzugsgebiet
------------------
DROP VIEW IF EXISTS {ext_schema}.einzugsgebiet;
CREATE VIEW {ext_schema}.einzugsgebiet
AS
SELECT
	  ca.obj_id
	, ca.runoff_limit_planned AS abflussbegrenzung_geplant
	, ca.runoff_limit_current AS abflussbegrenzung_ist
	, ca.discharge_coefficient_rw_planned AS abflussbeiwert_rw_geplant
	, ca.discharge_coefficient_rw_current AS abflussbeiwert_rw_ist
	, ca.discharge_coefficient_ww_planned AS abflussbeiwert_sw_geplant
	, ca.discharge_coefficient_ww_current AS abflussbeiwert_sw_ist
	, ca.seal_factor_rw_planned AS befestigungsgrad_rw_geplant
	, ca.seal_factor_rw_current AS befestigungsgrad_rw_ist
	, ca.seal_factor_ww_planned AS befestigungsgrad_sw_geplant
	, ca.seal_factor_ww_current AS befestigungsgrad_sw_ist
	, ca.identifier AS bezeichnung
	, ddp.value_de AS direkteinleitung_in_gewaesser_geplant
	, ddc.value_de AS direkteinleitung_in_gewaesser_ist
	, ca.population_density_planned AS einwohnerdichte_geplant
	, ca.population_density_current AS einwohnerdichte_ist
	, dsp.value_de AS entwaesserungssystemag_geplant
	, dsc.value_de AS entwaesserungssystemag_ist
	, ca.surface_area AS flaeche
	, ca.sewer_infiltration_water_production_planned AS fremdwasseranfall_geplant
	, ca.sewer_infiltration_water_production_current AS fremdwasseranfall_ist
	, ca.perimeter_geometry AS perimeter
	, 'Berechnungspunkt' AS perimetertyp
	, rp.value_de AS retention_geplant
	, rc.value_de AS retention_ist
	, ca.waste_water_production_planned AS schmutzabwasseranfall_geplant
	, ca.waste_water_production_current AS schmutzabwasseranfall_ist
	, ip.value_de AS versickerung_geplant
	, ic.value_de AS versickerung_ist
	, ca.fk_wastewater_networkelement_rw_planned AS gepknoten_rw_geplantref
	, ca.fk_wastewater_networkelement_rw_current AS gepknoten_rw_istref
	, ca.fk_wastewater_networkelement_ww_planned AS gepknoten_sw_geplantref
	, ca.fk_wastewater_networkelement_ww_current AS gepknoten_sw_istref
	, concat_ws('','ch113jqg0000',right(ca.fk_provider,8)) AS datenbewirtschafter_gep
	, ca.remark as bemerkung_gep
	, ca.last_modification as letzte_aenderung_gep
FROM tww_od.catchment_area ca
	LEFT JOIN tww_vl.catchment_area_direct_discharge_current ddc on ddc.code = ca.direct_discharge_current
	LEFT JOIN tww_vl.catchment_area_direct_discharge_planned ddp on ddp.code = ca.direct_discharge_planned
	LEFT JOIN tww_vl.catchment_area_drainage_system_current dsc on dsc.code = ca.drainage_system_current
	LEFT JOIN tww_vl.catchment_area_drainage_system_planned dsp on dsp.code = ca.drainage_system_planned
	LEFT JOIN tww_vl.catchment_area_infiltration_current ic on ic.code = ca.infiltration_current
	LEFT JOIN tww_vl.catchment_area_infiltration_planned ip on ip.code = ca.infiltration_planned
	LEFT JOIN tww_vl.catchment_area_retention_current rc on rc.code = ca.retention_current
	LEFT JOIN tww_vl.catchment_area_retention_planned rp on rp.code = ca.retention_planned	
;


----------------------------
-- Ueberlauf_Foerderaggregat
----------------------------
DROP VIEW IF EXISTS {ext_schema}.ueberlauf_foerderaggregat;
CREATE VIEW {ext_schema}.ueberlauf_foerderaggregat
AS
SELECT
	  ov.obj_id
	, CASE
	  WHEN pu.obj_id IS NOT NULL THEN 'Foerderaggregat' 
	  WHEN lw.obj_id IS NOT NULL THEN 'Leapingwehr' 
	  WHEN pw.obj_id IS NOT NULL THEN 'Streichwehr' 
	  END as art
	, ov.identifier as bezeichnung
	, ov.fk_wastewater_node as knotenref
	, ov.fk_overflow_to as knoten_nachref
	, concat_ws('','ch113jqg0000',right(ne.ag64_fk_provider,8)) AS datenbewirtschafter_wi
	, ov.ag64_remark as bemerkung_wi
	, ov.ag64_last_modification as letzte_aenderung_wi
	, concat_ws('','ch113jqg0000',right(ne.ag96_fk_provider,8)) AS datenbewirtschafter_gep
	, ov.ag96_remark as bemerkung_gep
	, ov.ag96_last_modification as letzte_aenderung_gep
FROM tww_od.overflow ov
    LEFT JOIN tww_od.pump pu ON ov.obj_id = pu.obj_id
	LEFT JOIN tww_od.leapingweir lw ON ov.obj_id = lw.obj_id
	LEFT JOIN tww_od.prank_weir pw ON ov.obj_id = pw.obj_id
	LEFT JOIN tww_od.wastewater_networkelement ne ON ne.obj_id=ov.fk_wastewater_node
;


----------------------------
-- Bautenausserhalbbaugebiet
----------------------------
DROP VIEW IF EXISTS {ext_schema}.bautenausserhalbbaugebiet;
CREATE OR REPLACE VIEW {ext_schema}.bautenausserhalbbaugebiet
AS
SELECT bg.obj_id,
    bg.ag96_population AS anzstaendigeeinwohner,
    COALESCE(bg_fct_rev.value_agxx, bg_fct.value_de::text) AS arealnutzung,
    bg_dt_ww.value_de AS beseitigung_haeusliches_abwasser,
    bg_dt_iw.value_de AS beseitigung_gewerbliches_abwasser,
    bg_dt_sw.value_de AS beseitigung_platzentwaesserung,
    bg_dt_rw.value_de AS beseitigung_dachentwaesserung,
    bg.identifier AS bezeichnung,
    bg.ag96_owner_address AS eigentuemeradresse,
    bg.ag96_owner_name AS eigentuemername,
    bg.population_equivalent AS einwohnergleichwert,
    bg.situation_geometry AS lage,
    bg.ag96_label_number AS nummer,
    initcap(bg_rn.value_de::text) AS sanierungsbedarf,
    bg.renovation_date AS sanierungsdatum,
    bg.restructuring_concept AS sanierungskonzept,
    concat_ws(''::text, 'ch113jqg0000', "right"(COALESCE(bg.fk_provider, '00000107'::character varying)::text, 8)) AS datenbewirtschafter_gep,
    bg.remark AS bemerkung_gep,
    COALESCE(bg.last_modification::timestamp with time zone, to_timestamp('1800-01-01'::text, 'YYYY-MM-DD'::text)) AS letzte_aenderung_gep
   FROM tww_od.building_group bg
     LEFT JOIN tww_vl.building_group_function bg_fct ON bg_fct.code = bg.function
     LEFT JOIN tww_ag6496.vl_building_group_function bg_fct_rev ON bg_fct_rev.code = bg.function
     LEFT JOIN tww_vl.building_group_renovation_necessity bg_rn ON bg_rn.code = bg.renovation_necessity
     LEFT JOIN tww_vl.building_group_ag96_disposal_type bg_dt_ww ON bg_dt_ww.code = bg.ag96_disposal_wastewater
     LEFT JOIN tww_vl.building_group_ag96_disposal_type bg_dt_iw ON bg_dt_iw.code = bg.ag96_disposal_industrial_wastewater
     LEFT JOIN tww_vl.building_group_ag96_disposal_type bg_dt_sw ON bg_dt_sw.code = bg.ag96_disposal_square_water
     LEFT JOIN tww_vl.building_group_ag96_disposal_type bg_dt_rw ON bg_dt_rw.code = bg.ag96_disposal_roof_water;
;


----------------------------
-- SBW_Einzugsgebiet
----------------------------
DROP VIEW IF EXISTS {ext_schema}.sbw_einzugsgebiet;
CREATE OR REPLACE VIEW {ext_schema}.sbw_einzugsgebiet
AS 
SELECT
	  cat.obj_id
	, cat.identifier AS bezeichnung
	, cat.population_dim AS einwohner_geplant
	, cat.population AS einwohner_ist
	, cat.surface_dim AS flaeche_geplant
	, cat.surface_area AS flaeche_ist
	, cat.surface_imp_dim AS flaeche_befestigt_geplant
	, cat.surface_imp AS flaeche_befestigt_ist
	, cat.surface_red_dim AS flaeche_reduziert_geplant
	, cat.surface_red AS flaeche_reduziert_ist
	, cat.ag96_sewer_infiltration_water_dim AS fremdwasseranfall_geplant
	, cat.sewer_infiltration_water AS fremdwasseranfall_ist
	, ca_agg.perimeter_geometry AS perimeter_ist
	, cat.ag96_waste_water_production_dim AS schmutzabwasseranfall_geplant
	, cat.waste_water_production AS schmutzabwasseranfall_ist
	, cat.fk_discharge_point AS einleitstelleref
	, wn.obj_id AS sonderbauwerk_ref
	, concat_ws('','ch113jqg0000',right(cat.fk_provider,8)) AS datenbewirtschafter_gep
	, hcd.remark as bemerkung_gep
	, cat.last_modification as letzte_aenderung_gep
FROM tww_od.catchment_area_totals cat
	LEFT JOIN tww_od.hydraulic_char_data hcd on hcd.obj_id = cat.fk_hydraulic_char_data and hcd.status = 6372 --Ist
	LEFT JOIN tww_od.wastewater_node wn on hcd.fk_wastewater_node=wn.obj_id
	LEFT JOIN tww_od.log_card lc ON lc.fk_pwwf_wastewater_node::text = wn.obj_id::text
    LEFT JOIN ( WITH ca AS (
                 SELECT catchment_area.fk_special_building_ww_current AS fk_log_card,
                    catchment_area.perimeter_geometry AS geom
                   FROM tww_od.catchment_area
                  WHERE catchment_area.fk_special_building_ww_current IS NOT NULL
                UNION
                 SELECT catchment_area.fk_special_building_rw_current AS fk_log_card,
                    catchment_area.perimeter_geometry AS geom
                   FROM tww_od.catchment_area
                  WHERE catchment_area.fk_special_building_rw_current IS NOT NULL
                ), collector AS (
                 SELECT main_lc.obj_id,
                    ca.geom
                   FROM ca
                     LEFT JOIN tww_od.log_card lc ON ca.fk_log_card::text = lc.obj_id::text
                     LEFT JOIN tww_od.log_card main_lc ON main_lc.obj_id::text = lc.fk_main_structure::text
                )
         SELECT collector.obj_id,
            st_unaryunion(st_collect(collector.geom)) AS perimeter_geometry
           FROM collector
          GROUP BY collector.obj_id) ca_agg ON ca_agg.obj_id::text = lc.obj_id::text
		  WHERE cat.surface_area IS NOT NULL
;	


----------------------------
-- VersickerungsbereichAG
----------------------------
DROP VIEW IF EXISTS {ext_schema}.versickerungsbereichag;
CREATE OR REPLACE VIEW {ext_schema}.versickerungsbereichag
 AS
 SELECT iz.obj_id,
    zo.identifier AS bezeichnung,
    iz.ag96_permeability AS durchlaessigkeit,
    iz.ag96_limitation AS einschraenkung,
    iz.ag96_thickness AS maechtigkeit,
    iz.perimeter_geometry AS perimeter,
    iz.ag96_q_check,
    iz_ic.value_de AS versickerungsmoeglichkeitag,
    concat_ws(''::text, 'ch113jqg0000', "right"(zo.fk_provider::text, 8)) AS datenbewirtschafter_gep,
    zo.remark AS bemerkung_gep,
    zo.last_modification AS letzte_aenderung_gep
   FROM tww_od.infiltration_zone iz
     LEFT JOIN tww_od.zone zo ON zo.obj_id::text = iz.obj_id::text
     LEFT JOIN tww_vl.infiltration_zone_infiltration_capacity iz_ic ON iz_ic.code = iz.infiltration_capacity;