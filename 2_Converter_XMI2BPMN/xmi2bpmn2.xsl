<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xmi="http://www.omg.org/XMI"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:bpmn2="http://www.omg.org/spec/BPMN/20100524/MODEL"
    exclude-result-prefixes="xmi">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <!-- Root template - convert Definitions -->
    <xsl:template match="bpmn2:definitions | bpmn2:Definitions">
        <bpmn2:definitions>
            <xsl:copy-of select="@*[local-name() != 'version' and namespace-uri() != 'http://www.omg.org/XMI']"/>
            <xsl:apply-templates select="*"/>
        </bpmn2:definitions>
    </xsl:template>

    <!-- Convert rootElements with xsi:type to proper BPMN elements -->
    <xsl:template match="rootElements[@xsi:type='bpmn2:Process'] | bpmn2:process">
        <bpmn2:process>
            <xsl:copy-of select="@id | @name | @isExecutable"/>
            <xsl:apply-templates select="flowElements | *[local-name()='flowElements']"/>
        </bpmn2:process>
    </xsl:template>

    <!-- Convert flowElements to proper BPMN elements -->
    <xsl:template match="flowElements[@xsi:type='bpmn2:StartEvent']">
        <bpmn2:startEvent>
            <xsl:copy-of select="@id | @name"/>
            <xsl:call-template name="create-outgoing-incoming"/>
        </bpmn2:startEvent>
    </xsl:template>

    <xsl:template match="flowElements[@xsi:type='bpmn2:EndEvent']">
        <bpmn2:endEvent>
            <xsl:copy-of select="@id | @name"/>
            <xsl:call-template name="create-outgoing-incoming"/>
        </bpmn2:endEvent>
    </xsl:template>

    <xsl:template match="flowElements[@xsi:type='bpmn2:UserTask']">
        <bpmn2:userTask>
            <xsl:copy-of select="@id | @name"/>
            <xsl:call-template name="create-outgoing-incoming"/>
        </bpmn2:userTask>
    </xsl:template>

    <xsl:template match="flowElements[@xsi:type='bpmn2:ReceiveTask']">
        <bpmn2:receiveTask>
            <xsl:copy-of select="@id | @name"/>
            <xsl:call-template name="create-outgoing-incoming"/>
        </bpmn2:receiveTask>
    </xsl:template>

    <xsl:template match="flowElements[@xsi:type='bpmn2:SendTask']">
        <bpmn2:sendTask>
            <xsl:copy-of select="@id | @name"/>
            <xsl:call-template name="create-outgoing-incoming"/>
        </bpmn2:sendTask>
    </xsl:template>

    <xsl:template match="flowElements[@xsi:type='bpmn2:ServiceTask']">
        <bpmn2:serviceTask>
            <xsl:copy-of select="@id | @name"/>
            <xsl:call-template name="create-outgoing-incoming"/>
        </bpmn2:serviceTask>
    </xsl:template>

    <xsl:template match="flowElements[@xsi:type='bpmn2:ManualTask']">
        <bpmn2:manualTask>
            <xsl:copy-of select="@id | @name"/>
            <xsl:call-template name="create-outgoing-incoming"/>
        </bpmn2:manualTask>
    </xsl:template>

    <xsl:template match="flowElements[@xsi:type='bpmn2:ScriptTask']">
        <bpmn2:scriptTask>
            <xsl:copy-of select="@id | @name"/>
            <xsl:call-template name="create-outgoing-incoming"/>
        </bpmn2:scriptTask>
    </xsl:template>

    <xsl:template match="flowElements[@xsi:type='bpmn2:ExclusiveGateway']">
        <bpmn2:exclusiveGateway>
            <xsl:copy-of select="@id | @name"/>
            <xsl:call-template name="create-outgoing-incoming"/>
        </bpmn2:exclusiveGateway>
    </xsl:template>

    <xsl:template match="flowElements[@xsi:type='bpmn2:ParallelGateway']">
        <bpmn2:parallelGateway>
            <xsl:copy-of select="@id | @name"/>
            <xsl:call-template name="create-outgoing-incoming"/>
        </bpmn2:parallelGateway>
    </xsl:template>

    <xsl:template match="flowElements[@xsi:type='bpmn2:InclusiveGateway']">
        <bpmn2:inclusiveGateway>
            <xsl:copy-of select="@id | @name"/>
            <xsl:call-template name="create-outgoing-incoming"/>
        </bpmn2:inclusiveGateway>
    </xsl:template>

    <xsl:template match="flowElements[@xsi:type='bpmn2:SequenceFlow']">
        <bpmn2:sequenceFlow>
            <xsl:copy-of select="@id | @name | @sourceRef | @targetRef"/>
        </bpmn2:sequenceFlow>
    </xsl:template>

    <!-- Template to convert incoming/outgoing attributes to nested elements -->
    <xsl:template name="create-outgoing-incoming">
        <xsl:if test="@incoming">
            <bpmn2:incoming><xsl:value-of select="@incoming"/></bpmn2:incoming>
        </xsl:if>
        <xsl:if test="@outgoing">
            <bpmn2:outgoing><xsl:value-of select="@outgoing"/></bpmn2:outgoing>
        </xsl:if>
    </xsl:template>

    <!-- Default template - ignore other elements -->
    <xsl:template match="text()"/>

</xsl:stylesheet>
