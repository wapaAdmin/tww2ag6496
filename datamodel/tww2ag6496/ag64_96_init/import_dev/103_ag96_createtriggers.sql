
DROP TRIGGER IF EXISTS on_gepknoten_upsert ON tww_ag6496.gepknoten;
CREATE TRIGGER on_gepknoten_upsert
    INSTEAD OF INSERT OR UPDATE 
    ON tww_ag6496.gepknoten
    FOR EACH ROW
    EXECUTE FUNCTION tww_ag6496.ft_gepknoten_upsert();

DROP TRIGGER IF EXISTS on_gepknoten_delete ON tww_ag6496.gepknoten;	
CREATE TRIGGER on_gepknoten_delete
    INSTEAD OF DELETE 
    ON tww_ag6496.gepknoten
    FOR EACH ROW
    EXECUTE FUNCTION tww_ag6496.ft_gepknoten_delete();
	
DROP TRIGGER IF EXISTS on_gephaltung_upsert ON tww_ag6496.gephaltung;	
CREATE TRIGGER on_gephaltung_upsert
    INSTEAD OF INSERT OR UPDATE 
    ON tww_ag6496.gephaltung
    FOR EACH ROW
    EXECUTE FUNCTION tww_ag6496.ft_gephaltung_upsert();
	
DROP TRIGGER IF EXISTS on_gephaltung_delete ON tww_ag6496.gephaltung;		
CREATE TRIGGER on_gephaltung_delete
    INSTEAD OF DELETE 
    ON tww_ag6496.gephaltung
    FOR EACH ROW
    EXECUTE FUNCTION tww_ag6496.ft_gephaltung_delete();

DROP TRIGGER IF EXISTS on_gepmassnahme_upsert ON tww_ag6496.gepmassnahme;	
CREATE TRIGGER on_gepmassnahme_upsert
    INSTEAD OF INSERT OR UPDATE 
    ON tww_ag6496.gepmassnahme
    FOR EACH ROW
    EXECUTE FUNCTION tww_ag6496.ft_gepmassnahme_upsert();

DROP TRIGGER IF EXISTS on_gepmassnahme_delete ON tww_ag6496.gepmassnahme;		
CREATE TRIGGER on_gepmassnahme_delete
    INSTEAD OF DELETE 
    ON tww_ag6496.gepmassnahme
    FOR EACH ROW
    EXECUTE FUNCTION tww_ag6496.ft_gepmassnahme_delete();

DROP TRIGGER IF EXISTS on_einzugsgebiet_upsert ON tww_ag6496.einzugsgebiet;	
CREATE TRIGGER on_einzugsgebiet_upsert
    INSTEAD OF INSERT OR UPDATE 
    ON tww_ag6496.einzugsgebiet
    FOR EACH ROW
    EXECUTE FUNCTION tww_ag6496.ft_einzugsgebiet_upsert();

DROP TRIGGER IF EXISTS on_einzugsgebiet_delete ON tww_ag6496.einzugsgebiet;		
CREATE TRIGGER on_einzugsgebiet_delete
    INSTEAD OF DELETE 
    ON tww_ag6496.einzugsgebiet
    FOR EACH ROW
    EXECUTE FUNCTION tww_ag6496.ft_einzugsgebiet_delete();

DROP TRIGGER IF EXISTS on_ueberlauf_foerderaggregat_upsert ON tww_ag6496.ueberlauf_foerderaggregat;		
CREATE TRIGGER on_ueberlauf_foerderaggregat_upsert
    INSTEAD OF INSERT OR UPDATE 
    ON tww_ag6496.ueberlauf_foerderaggregat
    FOR EACH ROW
    EXECUTE FUNCTION tww_ag6496.ft_ueberlauf_foerderaggregat_upsert();

DROP TRIGGER IF EXISTS on_ueberlauf_foerderaggregat_delete ON tww_ag6496.ueberlauf_foerderaggregat;		
CREATE TRIGGER on_ueberlauf_foerderaggregat_delete
    INSTEAD OF DELETE 
    ON tww_ag6496.ueberlauf_foerderaggregat
    FOR EACH ROW
    EXECUTE FUNCTION tww_ag6496.ft_ueberlauf_foerderaggregat_delete();

DROP TRIGGER IF EXISTS on_bautenausserhalbbaugebiet_upsert ON tww_ag6496.bautenausserhalbbaugebiet;	
CREATE TRIGGER on_bautenausserhalbbaugebiet_upsert
    INSTEAD OF INSERT OR UPDATE 
    ON tww_ag6496.bautenausserhalbbaugebiet
    FOR EACH ROW
    EXECUTE FUNCTION tww_ag6496.ft_bautenausserhalbbaugebiet_upsert();

DROP TRIGGER IF EXISTS on_bautenausserhalbbaugebiet_delete ON tww_ag6496.bautenausserhalbbaugebiet;		
CREATE TRIGGER on_bautenausserhalbbaugebiet_delete
    INSTEAD OF DELETE 
    ON tww_ag6496.bautenausserhalbbaugebiet
    FOR EACH ROW
    EXECUTE FUNCTION tww_ag6496.ft_bautenausserhalbbaugebiet_delete();

DROP TRIGGER IF EXISTS on_sbw_einzugsgebiet_upsert ON tww_ag6496.sbw_einzugsgebiet;	
CREATE TRIGGER on_sbw_einzugsgebiet_upsert
    INSTEAD OF INSERT OR UPDATE 
    ON tww_ag6496.sbw_einzugsgebiet
    FOR EACH ROW
    EXECUTE FUNCTION tww_ag6496.ft_sbw_einzugsgebiet_upsert();

DROP TRIGGER IF EXISTS on_sbw_einzugsgebiet_delete ON tww_ag6496.sbw_einzugsgebiet;		
CREATE TRIGGER on_sbw_einzugsgebiet_delete
    INSTEAD OF DELETE 
    ON tww_ag6496.sbw_einzugsgebiet
    FOR EACH ROW
    EXECUTE FUNCTION tww_ag6496.ft_sbw_einzugsgebiet_delete();

DROP TRIGGER IF EXISTS on_versickerungsbereichag_upsert ON tww_ag6496.versickerungsbereichag;	
CREATE TRIGGER on_versickerungsbereichag_upsert
    INSTEAD OF INSERT OR UPDATE 
    ON tww_ag6496.versickerungsbereichag
    FOR EACH ROW
    EXECUTE FUNCTION tww_ag6496.ft_versickerungsbereichag_upsert();

DROP TRIGGER IF EXISTS on_versickerungsbereichag_delete ON tww_ag6496.versickerungsbereichag;		
CREATE TRIGGER on_versickerungsbereichag_delete
    INSTEAD OF DELETE 
    ON tww_ag6496.versickerungsbereichag
    FOR EACH ROW
    EXECUTE FUNCTION tww_ag6496.ft_versickerungsbereichag_delete();

DROP TRIGGER IF EXISTS before_networkelement_change ON tww_od.wastewater_networkelement;		
CREATE TRIGGER before_networkelement_change
    BEFORE INSERT OR UPDATE 
    ON tww_od.wastewater_networkelement
    FOR EACH ROW
    EXECUTE FUNCTION tww_ag6496.update_last_ag_modification();

DROP TRIGGER IF EXISTS before_overflow_change ON tww_od.overflow;		
CREATE TRIGGER before_overflow_change
    BEFORE INSERT OR UPDATE 
    ON tww_od.overflow
    FOR EACH ROW
    EXECUTE FUNCTION tww_ag6496.update_last_ag_modification();