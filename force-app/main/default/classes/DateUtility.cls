public with sharing class DateUtility {
	public DateUtility(){}

	public String userLocaleInfo {
        get{
            return UserInfo.getLocale().substring(0,2);
        }
    }

    public String dateFormat {
        get{
            String userLocale = UserInfo.getLocale();
            return dateFormatMapJQuery().get(userLocale);
        }
    }

	public static Map<String,String> dateFormatMapJQuery(){
        Map<String, String> locale_map = new Map<String, String>(); //holds the locale to timedate formats
        locale_map.put('ar', 'dd/mm/yy');
        locale_map.put('ar_AE', 'dd/mm/yy');
        locale_map.put('ar_BH', 'dd/mm/yy');
        locale_map.put('ar_JO', 'dd/mm/yy');
        locale_map.put('ar_KW', 'dd/mm/yy');
        locale_map.put('ar_LB', 'dd/mm/yy');
        locale_map.put('ar_SA', 'dd/mm/yy');
        locale_map.put('bg_BG', 'yy-m-d');
        locale_map.put('ca', 'dd/mm/yy');
        locale_map.put('ca_ES', 'dd/mm/yy');
        locale_map.put('ca_ES_EURO', 'dd/mm/yy');
        locale_map.put('cs', 'd.m.yy');
        locale_map.put('cs_CZ', 'd.m.yy');
        locale_map.put('da', 'dd-mm-yy');
        locale_map.put('da_DK', 'dd-mm-yy');
        locale_map.put('de', 'dd.mm.yy');
        locale_map.put('de_AT', 'dd.mm.yy');
        locale_map.put('de_AT_EURO', 'dd.mm.yy');
        locale_map.put('de_CH', 'dd.mm.yy');
        locale_map.put('de_DE', 'dd.mm.yy');
        locale_map.put('de_DE_EURO', 'dd.mm.yy');
        locale_map.put('de_LU', 'dd.mm.yy');
        locale_map.put('de_LU_EURO', 'dd.mm.yy');
        locale_map.put('el_GR', 'd/m/yy');
        locale_map.put('en_AU', 'd/mm/yy');
        locale_map.put('en_B', 'm/d/yy');
        locale_map.put('en_Bm', 'm/d/yy');
        locale_map.put('en_CA', 'dd/mm/yy');
        locale_map.put('en_GB', 'dd/mm/yy');
        locale_map.put('en_GH', 'm/d/yy');
        locale_map.put('en_ID', 'm/d/yy');
        locale_map.put('en_IE', 'dd/mm/yy');
        locale_map.put('en_IE_EURO', 'dd/mm/yy');
        locale_map.put('en_NZ', 'd/mm/yy');
        locale_map.put('en_pk', 'dd/mm/yy');
        locale_map.put('en_SG', 'd/m/yy');
        locale_map.put('en_US', 'm/d/yy');
        locale_map.put('en_ZA', 'yy/mm/dd');
        locale_map.put('es', 'd/mm/yy');
        locale_map.put('es_AR', 'dd/mm/yy');
        locale_map.put('es_BO', 'dd-mm-yy');
        locale_map.put('es_CL', 'dd-mm-yy');
        locale_map.put('es_CO', 'd/mm/yy');
        locale_map.put('es_CR', 'dd/mm/yy');
        locale_map.put('es_EC', 'dd/mm/yy');
        locale_map.put('es_ES', 'd/mm/yy');
        locale_map.put('es_ES_EURO', 'd/mm/yy');
        locale_map.put('es_GT', 'd/mm/yy');
        locale_map.put('es_HN', 'mm-dd-yy');
        locale_map.put('es_mX', 'd/mm/yy');
        locale_map.put('es_PE', 'dd/mm/yy');
        locale_map.put('es_PR', 'mm-dd-yy');
        locale_map.put('es_PY', 'dd/mm/yy');
        locale_map.put('es_SV', 'mm-dd-yy');
        locale_map.put('es_UY', 'dd/mm/yy');
        locale_map.put('es_VE', 'dd/mm/yy');
        locale_map.put('et_EE', 'd.mm.yy');
        locale_map.put('fi', 'd.m.yy');
        locale_map.put('fi_FI', 'd.m.yy');
        locale_map.put('fi_FI_EURO', 'd.m.yy');
        locale_map.put('fr', 'dd/mm/yy');
        locale_map.put('fr_BE', 'd/mm/yy');
        locale_map.put('fr_CA', 'yy-mm-dd');
        locale_map.put('fr_CH', 'dd.mm.yy');
        locale_map.put('fr_FR', 'dd/mm/yy');
        locale_map.put('fr_FR_EURO', 'dd/mm/yy');
        locale_map.put('fr_LU', 'dd/mm/yy');
        locale_map.put('fr_mC', 'dd/mm/yy');
        locale_map.put('hr_HR', 'yy.mm.dd');
        locale_map.put('hu', 'yy.mm.dd.');
        locale_map.put('hy_Am', 'm/d/yy');
        locale_map.put('is_IS', 'd.m.yy');
        locale_map.put('it', 'dd/mm/yy');
        locale_map.put('it_CH', 'dd.mm.yy');
        locale_map.put('it_IT', 'dd/mm/yy');
        locale_map.put('iw', 'dd/mm/yy');
        locale_map.put('iw_IL', 'dd/mm/yy');
        locale_map.put('ja', 'yy/mm/dd');
        locale_map.put('ja_JP', 'yy/mm/dd');
        locale_map.put('kk_KZ', 'm/d/yy');
        locale_map.put('km_KH', 'm/d/yy');
        locale_map.put('ko', 'yy. m. d');
        locale_map.put('ko_KR', 'yy. m. d');
        locale_map.put('lt', 'yy/mm/dd');
        locale_map.put('lt_LT', 'yy.m.d');
        locale_map.put('lv_LV', 'yy.d.m');
        locale_map.put('ms_mY', 'dd/mm/yy');
        locale_map.put('nl', 'd-m-yy');
        locale_map.put('nl_BE', 'd/mm/yy');
        locale_map.put('nl_NL', 'd-m-yy');
        locale_map.put('nl_SR', 'd-m-yy');
        locale_map.put('no', 'dd.mm.yy');
        locale_map.put('no_NO', 'dd.mm.yy');
        locale_map.put('pl', 'yy-mm-dd');
        locale_map.put('pt', 'dd-mm-yy');
        locale_map.put('pt_AO', 'dd-mm-yy');
        locale_map.put('pt_BR', 'dd/mm/yy');
        locale_map.put('pt_PT', 'dd-mm-yy');
        locale_map.put('ro_RO', 'dd.mm.yy');
        locale_map.put('ru', 'dd.mm.yy');
        locale_map.put('sk_SK', 'd.m.yy');
        locale_map.put('sl_SI', 'd.m.y');
        locale_map.put('sv', 'yy-mm-dd');
        locale_map.put('sv_SE', 'yy-mm-dd');
        locale_map.put('th', 'm/d/yy');
        locale_map.put('th_TH', 'd/m/yy');
        locale_map.put('tr', 'dd.mm.yy');
        locale_map.put('ur_PK', 'm/d/yy');
        locale_map.put('vi_VN', 'dd/mm/yy');
        locale_map.put('zh', 'yy-m-d');
        locale_map.put('zh_CN', 'yy-m-d');
        locale_map.put('zh_HK', 'yy-m-d');
        locale_map.put('zh_TW', 'yy/m/d');
        return locale_map; //return the map
    }
}