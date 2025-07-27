@isTest
public class UpdateBookingStatusTest {
    @isTest static void testBookingStatusUpdate() {
        // Create test Contact
        Contact c = new Contact(FirstName = 'Test', LastName = 'User');
        insert c;

        // Create test Car
        Car__c car = new Car__c(
            Name = 'Test Car',
            Model_Number__c = 'T123',
            Manufacturer__c = 'Honda',
            Price__c = 500000,
            Availability__c = true // Updated field name
        );
        insert car;

        // Create test Car Booking
        Car_Booking__c booking = new Car_Booking__c(
            Customer__c = c.Id,
            Car__c = car.Id,
            Booking_Date__c = Date.today().addDays(1),
            Booking_Status__c = 'Pending'
        );
        insert booking;

        // Create Sales Order (trigger should run here)
        Sales_Order__c order = new Sales_Order__c(
            Car_Booking__c = booking.Id,
            Amount__c = 500000,
            Order_Date__c = Date.today(),
            Payment_Status__c = 'Unpaid'
        );
        insert order;

        // Re-fetch booking to verify status
        booking = [SELECT Booking_Status__c FROM Car_Booking__c WHERE Id = :booking.Id];
        System.assertEquals('Confirmed', booking.Booking_Status__c);
    }
}