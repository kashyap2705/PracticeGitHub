public class AccountService {

	public static Boolean isCached = false;
	public static Account account = null;
	public static Id accountId = null;

	public static void queryAccountById() {

		AccountDAO dao = AccountDAO.getInstance();
		account = dao.getAccountById(accountId);
		isCached = true;

	}

	public static Account getAccount() {

		if (!isCached) {
			queryAccountById();
		}

		return account;

	}

	public static void setAccountId(Id accId) {
		accountId = accId;
	}

}