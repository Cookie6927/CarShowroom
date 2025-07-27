trigger UpdateBookingStatus on Sales_Order__c (after insert){
    Set<Id> bookingIds = new Set<Id>();

    // Collect Car_Booking__c Ids from inserted Sales Orders
    for(Sales_Order__c so : Trigger.new) {
        if(so.Car_Booking__c != null) {
            bookingIds.add(so.Car_Booking__c);
        }
    }

    if(!bookingIds.isEmpty()) {
        List<Car_Booking__c> bookingsToUpdate = [SELECT Id, Booking_Status__c FROM Car_Booking__c WHERE Id IN :bookingIds];
        for(Car_Booking__c booking : bookingsToUpdate) {
            booking.Booking_Status__c = 'Confirmed';
        }
        update bookingsToUpdate;
    }
}