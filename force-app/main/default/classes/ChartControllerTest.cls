@isTest
public with sharing class ChartControllerTest {

    @isTest
    public static void testChartDataRetrieval() {
        // 1. Test the non-static instance method
        ChartController controller = new ChartController();
        
        Test.startTest();
        // This covers the public List<Data> getData() method
        List<ChartController.Data> resultFromInstance = controller.getData();
        
        // 2. Test the @RemoteAction static method
        // You call @RemoteAction methods just like any other static method
        List<ChartController.Data> resultFromRemote = ChartController.getRemoteData();
        Test.stopTest();

        // 3. Assertions: Verifying the results are correct
        // Verify size
        Assert.areEqual(12, resultFromInstance.size(), 'The instance method should return 12 data points.');
        Assert.areEqual(12, resultFromRemote.size(), 'The remote action should return 12 data points.');

        // Verify specific data (Jan)
        ChartController.Data janData = resultFromInstance[0];
        Assert.areEqual('Jan', janData.name, 'First month should be Jan.');
        Assert.areEqual(30, janData.data1, 'Jan data1 should be 30.');
        Assert.areEqual(90, janData.data2, 'Jan data2 should be 90.');
        Assert.areEqual(55, janData.data3, 'Jan data3 should be 55.');
    }
}