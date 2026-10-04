function validateDispatchForm() {
    let isValid = true;

    const incidentType = document.getElementById("incidentType").value.trim();
    const severity = document.getElementById("severity").value;
    const resourceId = document.getElementById("resourceId").value.trim();

    const incidentError = document.getElementById("incidentError");
    const severityError = document.getElementById("severityError");
    const resourceIdError = document.getElementById("resourceIdError");

    const resourceRegExp = /^RES-\d{4}$/;

    incidentError.style.display = "none";
    severityError.style.display = "none";
    resourceIdError.style.display = "none";

    if (incidentType === "" || incidentType.length < 3) {
        incidentError.style.display = "block";
        isValid = false;
    }

    if (severity === "") {
        severityError.style.display = "block";
        isValid = false;
    }

    if (!resourceRegExp.test(resourceId)) {
        resourceIdError.style.display = "block";
        isValid = false;
    }

    return isValid;
}