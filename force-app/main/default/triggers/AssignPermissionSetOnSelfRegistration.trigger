trigger AssignPermissionSetOnSelfRegistration on User (after insert) {
    // Define the Permission Set API Name (Update this to match your actual permission set name)
    String permissionSetName = 'Library_Community_User_Permissions';
    String profileName = 'Library Community User';

    System.debug('AssignPermissionSetOnSelfRegistration Trigger Started');

    // Fetch the Permission Set ID
    PermissionSet permSet;
    try {
        permSet = [SELECT Id FROM PermissionSet WHERE Name = :permissionSetName LIMIT 1];
    } catch (Exception e) {
        System.debug('Error fetching Permission Set: ' + e.getMessage());
        return; // Exit if the permission set is not found
    }

    // Fetch the Profile ID only once
    Id communityProfileId;
    try {
        communityProfileId = [SELECT Id FROM Profile WHERE Name = :profileName LIMIT 1].Id;
    } catch (Exception e) {
        System.debug('Error fetching Profile: ' + e.getMessage());
        return; // Exit if the profile is not found
    }

    // List to store permission set assignments
    List<PermissionSetAssignment> permAssignments = new List<PermissionSetAssignment>();

    for (User u : Trigger.new) {
        // Assign permission set only to users with the matching profile
        if (u.ProfileId == communityProfileId) {
            System.debug('Assigning Permission Set to User: ' + u.Id);
            permAssignments.add(new PermissionSetAssignment(
                AssigneeId = u.Id,
                PermissionSetId = permSet.Id
            ));
        }
    }

    // Assign the permission set if there are valid users
    if (!permAssignments.isEmpty()) {
        try {
            insert permAssignments;
            System.debug('Permission Sets Assigned Successfully');
        } catch (Exception e) {
            System.debug('Error assigning Permission Set: ' + e.getMessage());
        }
    }
}
