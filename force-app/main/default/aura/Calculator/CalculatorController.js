({
    addition : function(component, event, helper) {
        var num1 = component.get("v.num1");
        var num2 = component.get("v.num2");
        var add = num1 + num2 ; 
        component.set("v.output");
    }
})
