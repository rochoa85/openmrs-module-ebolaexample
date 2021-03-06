<%
    ui.includeJavascript("uicommons", "handlebars/handlebars.min.js")
    ui.includeCss("ebolaexample", "overview/ebolaOverview.css")
    ui.decorateWith("appui", "standardEmrPage")

    ui.includeJavascript("uicommons", "angular.min.js")
    ui.includeJavascript("uicommons", "angular-app.js")
    ui.includeJavascript("uicommons", "angular-resource.min.js")
    ui.includeJavascript("uicommons", "angular-common.js")

    ui.includeJavascript("ebolaexample", "tabletapp/feature-toggles.js")
%>
<script type="text/template" id="last-encounter-template">
<!-- TO DO: do not make this template more complex! We need to provide a better representation, e.g. that knows about symptoms  -->
<ul>
    <li>
        <em>
            {{display location}}
            -
            {{date encounterDatetime}}
        </em>
    </li>
    {{#each obs}}
    <li>
        {{#if this.value}}
        {{display this.concept}}: {{display this.value}}
        {{else}}
        {{#each this.groupMembers}}
        {{display this.value}}
        {{/each}}
        {{/if}}
    </li>
    {{/each}}
</ul>
</script>

<script type="text/javascript">
    var breadcrumbs = [
        {icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm'},
        <% if (wardAndBed && wardAndBed.ward) { %>
        {
            label: "${ ui.format(wardAndBed.ward) }",
            link: '${ ui.escapeJs(ui.pageLink("ebolaexample", "activePatients", [ ward: wardAndBed.ward.uuid ])) }'
        },
        <% } %>
        {label: "${ ui.escapeJs(ui.message("ebolaexample.ebolaOverview.title")) }"}
    ]
    var patient = {id: ${ patient.id }};

    Handlebars.registerHelper('display', function (obj) {
        return obj ? (obj.display ? obj.display : obj) : "";
    });
    Handlebars.registerHelper('date', function (obj) {
        return obj ? new Date(obj).toLocaleString() : "";
    });

    var lastEncounterTemplate = Handlebars.compile(jq('#last-encounter-template').html());
</script>

<% if (includeFragments) {
    includeFragments.each {
%>
${ui.includeFragment(it.extensionParams.provider, it.extensionParams.fragment)}
<% }
} %>

${ui.includeFragment("ebolaexample", "overview/patientHeader", [patient: patient.patient, activeVisit: activeVisit, appContextModel: appContextModel])}


<div class="info-body jump-header">
    <span class="jump-label">Jump to:</span>
    <i class="icon-medkit"><a href="#laboratory">Lab results</a></i>
    <i class="icon-vitals"><a href="#vitals">Vitals</a></i>
    <i class="icon-medkit"><a href="#symptoms">Symptoms</a></i>
    <i class="icon-medkit"><a href="#prescriptions">Prescriptions</a></i>
    <i class="icon-medkit"><a href="#med-admin">Med admin</a></i>
    <i class="icon-medkit"><a href="#ivfluids">IV fluids</a></i>

    <i class="icon-medkit"
       ng-app="feature-toggles"
       ng-show = "isFeatureEnabled('clinicalNote')"
       ng-controller="FeatureToggleController"><a href="${ui.pageLink("ebolaexample", "clinicalNotes", [patient: patient.patient.id])}">Clinical notes</a></i>
</div>
<div class="clear"></div>

<div class="container">

    <div class="dashboard clear">



        <div class="long-info-container column">
            ${ui.includeFragment("ebolaexample", "overview/ebolaProgram", [patient: patient])}
        </div>

        <div class="clear"></div>



        <div class="clear"></div>
        <br/>
        <div class="long-info-container column">
            ${ui.includeFragment("ebolaexample", "overview/laboratory", [patient: patient])}
            ${ui.includeFragment("ebolaexample", "overview/vitals", [patient: patient])}
            ${ui.includeFragment("ebolaexample", "overview/symptoms", [patient: patient])}
            ${ui.includeFragment("ebolaexample", "overview/prescriptions", [patient: patient])}
            <br/>
            ${ui.includeFragment("ebolaexample", "overview/scheduledDoseHistory", [patient: patient])}
            <br/>
            ${ui.includeFragment("ebolaexample", "overview/ivFluidOrders", [patient: patient])}
        </div>

    </div>
</div>