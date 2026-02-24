# SPLE BPMN Extension - Usage Guide

## BPMN 2.0 Extension Mechanism for External Schemas

This guide explains how to use the SPLE variability extension with BPMN 2.0.

---

## Important: Extension Placement

For **external custom extensions** (not extending BPMN core), extension elements **MUST** be placed inside `<bpmn2:extensionElements>` containers. The BaseElement class in BPMN 2.0 includes a wildcard that accepts `##other` namespace elements.

### ✅ CORRECT Pattern:

```xml
<bpmn2:task id="Task_1" name="My Task">
    <bpmn2:extensionElements>
        <sple:variabilityType>optional</sple:variabilityType>
        <sple:include>false</sple:include>
        <sple:condition>feature.x == true</sple:condition>
    </bpmn2:extensionElements>
</bpmn2:task>
```

### ❌ WRONG Pattern (will cause errors):

```xml
<bpmn2:task id="Task_1" name="My Task">
    <sple:variabilityType>optional</sple:variabilityType>
    <sple:include>false</sple:include>
</bpmn2:task>
```

---

## Extension Schema Structure

The schema defines extension elements but they are accessed through `extensionElements`:

```xml
<!-- spleExtension.xsd -->
<xsd:element name="variabilityType" type="sple:tVariabilityKind"/>
<xsd:element name="include" type="xsd:boolean"/>
<xsd:element name="variant" type="sple:tVariant"/>
<!-- etc. -->
```

---

## Usage Patterns

### Pattern 1: Optional Element

**When to use:** An element that may or may not be included in the derived model.

```xml
<bpmn2:task id="Task_EmailNotification" name="Send Email">
    <bpmn2:incoming>Flow_1</bpmn2:incoming>
    <bpmn2:outgoing>Flow_2</bpmn2:outgoing>
    
    <!-- Extension elements MUST be inside extensionElements container -->
    <bpmn2:extensionElements>
        <sple:variabilityType>optional</sple:variabilityType>
        <sple:include>false</sple:include>
        <sple:exclude>true</sple:exclude>
        <sple:bindingTime phase="deployment-time">customer_config</sple:bindingTime>
        <sple:condition language="expression">feature.email == true</sple:condition>
    </bpmn2:extensionElements>
</bpmn2:task>
```

### Pattern 2: Alternative Elements

**When to use:** Mutually exclusive choices (XOR).

```xml
<bpmn2:exclusiveGateway id="Gateway_Payment" name="Payment Method">
    <bpmn2:incoming>Flow_1</bpmn2:incoming>
    <bpmn2:outgoing>Flow_2a</bpmn2:outgoing>
    <bpmn2:outgoing>Flow_2b</bpmn2:outgoing>
    
    <bpmn2:extensionElements>
        <sple:variabilityType>alternative</sple:variabilityType>
        <sple:bindingTime phase="runtime">user_selection</sple:bindingTime>
        
        <!-- Multiple variant options -->
        <sple:variant id="var_credit" selected="true">
            <sple:name>Credit Card</sple:name>
            <sple:condition>payment.type == 'credit'</sple:condition>
            <sple:enabled>true</sple:enabled>
            <sple:priority>1</sple:priority>
        </sple:variant>
        
        <sple:variant id="var_paypal" selected="false">
            <sple:name>PayPal</sple:name>
            <sple:condition>payment.type == 'paypal'</sple:condition>
            <sple:enabled>true</sple:enabled>
            <sple:priority>2</sple:priority>
        </sple:variant>
    </bpmn2:extensionElements>
</bpmn2:exclusiveGateway>
```

### Pattern 3: OR Elements

**When to use:** One or more options can be selected (non-exclusive).

```xml
<bpmn2:task id="Task_Notify" name="Send Notifications">
    <bpmn2:extensionElements>
        <sple:variabilityType>or</sple:variabilityType>
        <sple:condition>config.notify == true</sple:condition>
        
        <sple:variant id="var_email">
            <sple:name>Email</sple:name>
            <sple:enabled>true</sple:enabled>
        </sple:variant>
        
        <sple:variant id="var_sms">
            <sple:name>SMS</sple:name>
            <sple:enabled>true</sple:enabled>
        </sple:variant>
        
        <sple:variant id="var_push">
            <sple:name>Push Notification</sple:name>
            <sple:enabled>false</sple:enabled>
        </sple:variant>
    </bpmn2:extensionElements>
</bpmn2:task>
```

### Pattern 4: Mandatory Element

**When to use:** Element must always be included.

```xml
<bpmn2:task id="Task_Validate" name="Validate Input">
    <bpmn2:extensionElements>
        <sple:variabilityType>mandatory</sple:variabilityType>
        <sple:include>true</sple:include>
    </bpmn2:extensionElements>
</bpmn2:task>
```

---

## Extension Elements Reference

### `<sple:variabilityType>`

Specifies the type of variability.

**Type:** Enumeration  
**Values:** `optional` | `alternative` | `or` | `mandatory`

### `<sple:include>`

Flag indicating if element should be included.

**Type:** Boolean  
**Default:** `true`

### `<sple:exclude>`

Flag indicating if element should be excluded.

**Type:** Boolean  
**Default:** `false`

### `<sple:variant>`

Defines a variant option with detailed configuration.

**Attributes:**
- `id` (required): Unique identifier
- `selected`: Whether this variant is currently selected

**Child elements:**
- `<name>`: Human-readable name
- `<condition>`: Expression to evaluate
- `<enabled>`: Whether variant is enabled
- `<priority>`: Priority order (integer)

### `<sple:bindingTime>`

Specifies when the variability is resolved.

**Attributes:**
- `phase`: `design-time` | `deployment-time` | `runtime`

**Content:** Description of binding context

### `<sple:condition>`

Expression defining when element is active.

**Attributes:**
- `language`: Expression language (default: "expression")

**Content:** The condition expression

---

## Why Use `<extensionElements>`?

The BPMN 2.0 `BaseElement` class (which all BPMN elements inherit from) includes an `extensionValues` feature that maps to `<extensionElements>` in XML. This element has a wildcard allowing `##other` namespace elements.

**From BPMN20.ecore:**
```xml
<eStructuralFeatures xsi:type="ecore:EReference" name="extensionValues">
    <eAnnotations source="http:///org/eclipse/emf/ecore/util/ExtendedMetaData">
        <details key="kind" value="element"/>
        <details key="name" value="extensionElements"/>
        <details key="wildcards" value="##other"/>
    </eAnnotations>
</eStructuralFeatures>
```

This means:
- ✅ Any element from another namespace can go inside `<extensionElements>`
- ✅ BPMN tools will preserve these elements even if they don't understand them
- ✅ Eclipse BPMN2 modeler recognizes this pattern

---

## Extension Declaration (Optional)

While not strictly required when using `<extensionElements>`, you can still declare your extension for documentation:

```xml
<bpmn2:definitions 
    xmlns:bpmn2="http://www.omg.org/spec/BPMN/20100524/MODEL"
    xmlns:sple="http://sple/bpmn/extensions"
    id="Definitions_1">
    
    <!-- Optional: Document the extension for tool support -->
    <bpmn2:extension mustUnderstand="false" definition="sple:variabilityElements"/>
    
    <bpmn2:process id="Process_1">
        <bpmn2:task id="Task_1">
            <bpmn2:extensionElements>
                <sple:variabilityType>optional</sple:variabilityType>
            </bpmn2:extensionElements>
        </bpmn2:task>
    </bpmn2:process>
</bpmn2:definitions>
```

---

## Complete Example Workflow

1. **Create the extension schema** (`spleExtension.xsd`)
   - Define elements
   - Define complex types
   - Define enumerations

2. **Add namespace to BPMN definitions**
   ```xml
   <bpmn2:definitions 
       xmlns:bpmn2="http://www.omg.org/spec/BPMN/20100524/MODEL"
       xmlns:sple="http://sple/bpmn/extensions">
   ```

3. **Use extension elements inside `<extensionElements>`**
   ```xml
   <bpmn2:task id="Task_1">
       <bpmn2:extensionElements>
           <sple:variabilityType>optional</sple:variabilityType>
           <sple:include>false</sple:include>
       </bpmn2:extensionElements>
   </bpmn2:task>
   ```

4. **Validate** the BPMN file
   - Eclipse will preserve extension elements
   - Your transformation can read extension elements

---

## How Eclipse BPMN2 Modeler Handles Extensions

Eclipse BPMN2 Modeler:
- ✅ **Preserves** extension elements inside `<extensionElements>`
- ✅ **Allows** any namespace elements via `##other` wildcard
- ✅ **Stores** extension data even if not visible in UI
- ❌ **Does not validate** against your custom schema (unless plugin installed)

The errors you saw were because elements were placed outside `<extensionElements>`, where they are not allowed by the BPMN 2.0 core schema.

---

## Binding Time Phases

### Design-Time
Variability resolved during model design.
```xml
<sple:bindingTime phase="design-time">modeler_selection</sple:bindingTime>
```

### Deployment-Time
Variability resolved when deploying to a specific environment.
```xml
<sple:bindingTime phase="deployment-time">environment_config</sple:bindingTime>
```

### Runtime
Variability resolved during process execution.
```xml
<sple:bindingTime phase="runtime">user_input</sple:bindingTime>
```

---

## Best Practices

1. **Always use `<extensionElements>` container** for custom extensions
2. **Declare namespace** in `<definitions>` element
3. **Use meaningful element names** that clearly indicate purpose
4. **Document your extensions** in the schema with annotations
5. **Keep extension elements optional** (minOccurs="0") for flexibility
6. **Test with target BPMN tools** to ensure compatibility

---

## References

- BPMN 2.0 Specification, Section 8 (Extensibility)
- BPMN 2.0 XSD Schema - BaseElement `extensionValues`
- Schema file: `spleExtension.xsd`
- Example file: `example-sple-usage.bpmn2`
