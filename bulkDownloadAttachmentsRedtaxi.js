function saveTodaysAttachmentsFromEmail() {
  const emailAddress = "customersupport@redtaxi.co.in"; // change this

  // Get today's date in YYYY/MM/DD
  const today = new Date();
  const year = today.getFullYear();
  const month = ("0" + (today.getMonth() + 1)).slice(-2); // pad with 0
  const day = ("0" + today.getDate()).slice(-2);

  const todayStr = year + "/" + month + "/" + day;

  // Gmail search for mails from today only
  const query = 'from:' + emailAddress + ' after:' + todayStr + ' before:' + year + '/' + month + '/' + (("0" + (today.getDate() + 1)).slice(-2));
  const threads = GmailApp.search(query);

  // Create folder named with today's date
  const folderName = "Attachments_" + todayStr.replace(/\//g, "-") + "_" + emailAddress;
  const folder = DriveApp.createFolder(folderName);

  threads.forEach(thread => {
    const messages = thread.getMessages();
    messages.forEach(message => {
      const attachments = message.getAttachments();
      attachments.forEach(attachment => {
        folder.createFile(attachment);
      });
    });
  });

  Logger.log("Attachments saved to folder: " + folder.getUrl());
}
