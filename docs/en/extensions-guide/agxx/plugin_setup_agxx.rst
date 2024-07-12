.. _plugin_setup_agxx

Plugin and Project Setup
=======================

In order to use the AG-64/AG-96 extension, the database must be initialized accordingly. See `initialize database extensions <../initialize_extensions.html>_` for further explanations.


.. _interlis_setup_agxx
Enable AG-64/AG-96 Interlis Imports and Exports
^^^^^^^^^^^^^^^^^^^^^^

In the plugin, there is a hidden functionality that allows importing and exporting AG-64/AG-96 interlis files. In order to activate it, one needs to open the TWW settings

 .. figure:: images/opensettingsdialog.png
 
In the tab *Developer options*, there is a Checkbox to enable the AG-64/96 extension

 .. figure:: images/opensettingsdialog.png
 
 When this checkbox is ticked, the data models AG-64/AG-96 are available in the interlis export.
 
 .. _project_setup_agxx
Project setup
^^^^^^^^^^^^^^^^^^^^^^

The attribute forms of AG-64/AG-96 are not loaded automatically when starting the template .qgs project. The necessary forms are available in source code of the  `latest release <https://github.com/teksi/wastewater/releases/latest>_`

* download source code
* in the folder project/agxx there are qml files with the necessary attribute forms
 
