<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : Intervention infirmière.xsl
    Created on : 9 November 2022, 09:26
    Author     : soule
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:cab="http://www.ujf-grenoble.fr/l3miage/medical"
                xmlns:act="http://www.ujf-grenoble.fr/l3miage/actes"
                xmlns="http://www.w3.org/1999/xhtml">
    <xsl:output method="html"/>

    <!-- TODO customize transformation rules 
         syntax recommendation http://www.w3.org/TR/xslt 
    -->
    
    <!-- Page de l'infirmière avec l'identifiant suivant -->
    <xsl:param name="destinedId" select="001"/>
    
    <!-- VARIABLES -->
    <!-- Variable visiteDuJour qui contient l'ensemble des noeuds visite correspondant à cette infirmière -->
    <xsl:variable name="visiteDuJour" select="//cab:patient/cab:visite[@intervenant=$destinedId]"/>
                
    <!-- Variable nbrePatients qui contient le nombre de patient de l'infirmière -->
    <xsl:variable name="nbrePatients" select="count($visiteDuJour)"/>
                
    <!-- Variable actes contenant les noeuds ngap du document actes.xml -->
    <xsl:variable name="actes" select="document('../xml/actes.xml', /)/act:ngap"/>
                
    <!-- Variable espace qui crée un espace -->
    <xsl:variable name="espace" select="' '"/>
    
    
    <!-- Template final affichant la page de l'infirmière -->
    <!-- Affiche par exemple :
    Bonjour Annie,
    Aujourd'hui, vous avez 5 patients -->
    <xsl:template match="/">
        <html>
            <head>
                <title>Infirmiere 001</title>
                <!-- Bouton facture des patients -->
                <script type="text/javascript">
                    function openFacture(prenom, nom, actes) {
                    var width  = 500;
                    var height = 300;
                    if(window.innerWidth) {
                    var left = (window.innerWidth-width)/2;
                    var top = (window.innerHeight-height)/2;
                    }
                    else {
                    var left = (document.body.clientWidth-width)/2;
                    var top = (document.body.clientHeight-height)/2;
                    }
                    var factureWindow = window.open('','facture','menubar=yes, scrollbars=yes, top='+top+', left='+left+', width='+width+', height='+height+'');
                    factureText = "Facture pour : " + prenom + " " + nom;
                    factureWindow.document.write(factureText);
                    }
                </script>
            </head>
            <body>  
                <!-- AFFICHAGE -->
                Bonjour <xsl:value-of select="//cab:infirmier[@id=$destinedId]/cab:prenom/text()"/> 
                <br/>
                Aujourd'hui, vous avez <xsl:value-of select="$nbrePatients"/> patient(s) <br/>
                <br/>
                
                <xsl:apply-templates select="$visiteDuJour/.."/>
                
            </body>
        </html>
    </xsl:template>
    
    
    <!-- Templates donnant les renseignement sur chaque patient de l'infirmière -->
    <!-- Ecrit son nom, son prénom, son adresse et la liste des soins à faire -->
    <xsl:template match="cab:patient">
        <b>Patient <xsl:value-of select="position()"/>/<xsl:value-of select="$nbrePatients"/>:</b>
        <br/>
        Nom : <xsl:value-of select="cab:nom"/>
        <br/>
        Prénom : <xsl:value-of select="cab:prénom"/>
        <br/>
        Adresse : <xsl:value-of select="cab:adresse/cab:numéro"/> 
        <xsl:value-of select="$espace"/> 
        <xsl:value-of select="cab:adresse/cab:rue"/>  
        <xsl:value-of select="$espace"/> 
        <xsl:value-of select="cab:adresse/cab:codePostal"/>, <xsl:value-of select="cab:adresse/cab:ville"/>
        <br/>
        Soins à effectuer : <br/>
        <xsl:apply-templates select="cab:visite[@intervenant=$destinedId]/cab:acte"/> 
        <br/>
        
        <!-- Bouton facture -->
        <xsl:element name="input">
            <xsl:attribute name="type">Submit</xsl:attribute>
            <xsl:attribute name="value">Facture</xsl:attribute>
            <xsl:attribute name="onclick">
                openFacture('<xsl:value-of select="cab:prénom"/>',
                '<xsl:value-of select="cab:nom"/>',
                '<xsl:apply-templates select="cab:visite[@intervenant=$destinedId]"/>')
            </xsl:attribute>
        </xsl:element>
        <br/><br/>
    </xsl:template>
    
    
    <!-- Template qui récupère la liste des actes d'une visite d'un patient -->
    <xsl:template match="cab:visite">
        <xsl:value-of select="cab:acte"/><br/>
    </xsl:template>
    
    
    <!-- Template qui écrit le soin lié à un acte -->
    <xsl:template match="cab:acte">
        <xsl:variable name="id" select="@id"/>
        <xsl:value-of select="$actes/act:actes/act:acte[@id=$id]/text()"/>
        <br/>
    </xsl:template>
</xsl:stylesheet>
