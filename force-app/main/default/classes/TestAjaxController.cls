@isTest
private class TestAjaxController {

    
    @isTest
    private static void testGoodAjax(){
        AjaxController aj = new AjaxController();
		Assert.isTrue(aj.count == 0);
		PageReference pr = aj.incrementCount();
        System.debug('< The value of count is >: '+aj.getCount());
		Assert.isTrue(pr == null);
		Assert.IsTrue(aj.count > 0);
        
    }
}