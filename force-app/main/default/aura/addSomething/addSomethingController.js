({
    addNumbers : function(component, event) {
        var num1 = component.get("v.num1");
        var num2 = component.get("v.num2");
        var result = num1 + num2;
        component.set("v.result", result);
    }           ,
})