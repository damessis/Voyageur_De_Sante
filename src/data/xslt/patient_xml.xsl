<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : patient.xsl
    Created on : 16 November 2022, 11:22
    Author     : soule
    Description:
        Purpose of transformation follows.
-->

<xs:stylesheet xmlns:xs="http://www.w3.org/1999/XSL/Transform" version="1.0"
               xmlns:cab="http://www.ujf-grenoble.fr/l3miage/medical"
               xmlns:act="http://www.ujf-grenoble.fr/l3miage/actes">
    <xs:output method="xml"
               indent="yes"/>

    
    <!-- ...................................... PARAMETRES ...................................... -->
    <!-- Paramètre donnant le nom du patient -->
    <xs:param name="destinedName" select="'Alécole'"/>
    
    <!-- ...................................... VARIABLES ...................................... -->
    <!-- Variable actes contenant les noeuds ngap du document actes.xml -->
    <xs:variable name="actes" select="document('../xml/actes.xml', /)/act:ngap"/>
    
    
    <!-- ...................................... TEMPLATES ...................................... -->
    <!-- Template qui va créé un fichier patient_NOMPATIENT.xml avec tous les renseignements d'un patient :
            Lorsqu'un patient fait cette demande, un nouveau fichier XML est généré qui contient
            les informations le concernant (état civil, adresse, téléphone ...), ce qui lui permettra
            de vérifier ces informations et d'envoyer une requête de modification le cas échéant.
            Ce fichier contiendra également la liste des visites médicales le concernant avec toutes les
            informations écrites en clair, à savoir la date, le libellé exact de l'acte médical,
            et le nom de l'infirmier qui viendra pour chaque visite.

            AFFICHE : 
            <patient>
                TEMPLATE PATIENT
            </patient>    -->
    <xs:template match="/">
        <patient>
            <xs:apply-templates select="//cab:patient[cab:nom=$destinedName]"/>
        </patient>
    </xs:template>

    
    <!-- Template qui récupère les informations du patient mis en paramètre
            AFFICHE :
            <nom>Pourferlavésel</nom>
            <prénom>Vladimir</prénom>
            <sexe>M</sexe>
            <naissance>1942-12-30</naissance>
            <numéroSS>198082205545842</numéroSS>
            <adresse>
                <rue>Les morets</rue>
                <codePostal>38112</codePostal>
                <ville>Méaudre</ville>
            </adresse>
            TEMPLATE VISITE    -->
    <xs:template match="cab:patient">
            <nom> <xs:value-of select="$destinedName"/> </nom>
            <prénom> <xs:value-of select="cab:prénom/text()"/> </prénom>
            <sexe> <xs:value-of select="cab:sexe/text()"/> </sexe>
            <naissance> <xs:value-of select="cab:naissance/text()"/> </naissance>
            <numéroSS> <xs:value-of select="cab:numéro/text()"/> </numéroSS>
            <adresse>
                <numéro> <xs:value-of select="cab:adresse/cab:numéro/text()"/> </numéro>
                <rue> <xs:value-of select="cab:adresse/cab:rue/text()"/> </rue>
                <ville> <xs:value-of select="cab:adresse/cab:ville/text()"/> </ville>
                <codePostal> <xs:value-of select="cab:adresse/cab:codePostal/text()"/> </codePostal>
            </adresse>
            <xs:apply-templates select="cab:visite"/>
    </xs:template>
    
    <!-- Template qui liste les visites du patient avec les informations concernant celles-ci
            AFFICHE :
            <visite date="2017-12-11">
                TEMPLATE INFIRMIER S'IL Y EN A UN
                TEMPLATE ACTE
            </visite> -->
    <xs:template match="cab:visite">
        <xs:variable name="intervenant" select="@intervenant"/>
        <xs:variable name="date" select="@date"/>
        <visite>
            <xs:attribute name="date">
                <xs:value-of select="@date"/>
            </xs:attribute>
            <xs:apply-templates select="../../../cab:infirmiers/cab:infirmier[@id=$intervenant]"/>
            <xs:apply-templates select="cab:acte"/>
        </visite>
    </xs:template>
    
    <!-- Template qui donne les informations de l'intervenant
            AFFICHE :
            <intervenant>
                <nom>Fréchie</nom>
                <prénom>Sarah</prénom>
            </intervenant> -->
    <xs:template match="cab:infirmier">
        <intervenant>
            <nom> <xs:value-of select="cab:nom/text()"/> </nom>
            <prénom> <xs:value-of select="cab:prenom/text()"/> </prénom>
        </intervenant>
    </xs:template>
    
    <!-- Template qui écrit le soin lié à un 
            AFFICHE :
            <acte>Ablation de fils ou d'agrafes, plus de dix, y compris le pansement éventuel.</acte> -->
    <xs:template match="cab:acte">
        <xs:variable name="id" select="@id"/>
        <acte> <xs:value-of select="$actes/act:actes/act:acte[@id=$id]/text()"/> </acte>
    </xs:template>
</xs:stylesheet>
