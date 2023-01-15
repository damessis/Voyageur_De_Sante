<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : patientHTML.xsl
    Created on : 26 November 2022, 14:30
    Author     : soule
    Description:
        Purpose of transformation follows.
-->

<xs:stylesheet xmlns:xs="http://www.w3.org/1999/XSL/Transform" version="1.0"
               xmlns:cab="http://www.ujf-grenoble.fr/l3miage/medical"
               xmlns="http://www.w3.org/1999/xhtml">
    <xs:output method="html"/>
    
    
    <!-- Variable espace qui crée un espace -->
    <xs:variable name="espace" select="' '"/>
    

    <!-- Template racine qui est capable de transformer le fichier patient (ex: patient_Pourferlavésel.xml)
         en une page HTMl fiche_patient.html lui rappelant ses renseignements et listant dans un tableau ses
         visites, leur libellé et le nom de l'intervenant. -->
    <xs:template match="/">
        <html>
            <head>
                <title>patient</title>
                <link rel="stylesheet" href="../css/style.css"/>
            </head>
            <body>
                <xs:apply-templates select="cab:patient"/>
            </body>
        </html>
    </xs:template>
    
    
    <!-- Template qui va afficher les informations du patient -->
    <xs:template match="cab:patient">
        <h3> Informations : </h3>
        Nom : <xs:value-of select="cab:nom/text()"/> <br/>
        Prénom : <xs:value-of select="cab:prénom/text()"/> <br/>
        Sexe : <xs:value-of select="cab:sexe/text()"/> <br/>
        Date de naissance : <xs:value-of select="cab:naissance/text()"/> <br/>
        Adresse : <xs:value-of select="cab:adresse/cab:numéro"/> 
        <xs:value-of select="$espace"/> 
        <xs:value-of select="cab:adresse/cab:rue"/>  
        <xs:value-of select="$espace"/> 
        <xs:value-of select="cab:adresse/cab:codePostal"/>, <xs:value-of select="cab:adresse/cab:ville"/> <br/>
        
        <h3> Visite(s) : </h3>
        <table>
            <tr>
                <th>Date</th>
                <th>Acte</th>
                <th>Intervenant (Nom Prénom)</th>
            </tr>
            <xs:apply-templates select="cab:visite"/>
        </table>
    </xs:template>
    
    
    <!-- Template qui complète le tableau Visite -->
    <xs:template match="cab:visite">  
            <tr>
                <td> <xs:value-of select="@date"/> </td>
                <td> <xs:apply-templates select="cab:acte"/> </td>
                <xs:apply-templates select="cab:intervenant"/>
            </tr>
    </xs:template>
    
    
    <!-- Template qui écrit les actes pour chaque visite -->
    <xs:template match="cab:acte">
        - <xs:value-of select="."/> <br/>
    </xs:template>
    
    
    <!-- Template qui écrit le nom prénom de l'intervenant pour chaque visite -->
    <xs:template match="cab:intervenant">
        <td> <xs:value-of select="cab:nom"/> <xs:value-of select="$espace"/> <xs:value-of select="cab:prénom"/> </td>
    </xs:template>

</xs:stylesheet>
