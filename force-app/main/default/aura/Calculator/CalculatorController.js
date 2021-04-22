({
    abcFuntion : function(component, event, helper) {
        console.log("abc Function");
        var action=  component.get('c.getmymap');  // Calling apex method
        action.setCallback(this,function(response){
            
        });
        $A.enqueueAction(action);
    }
})
