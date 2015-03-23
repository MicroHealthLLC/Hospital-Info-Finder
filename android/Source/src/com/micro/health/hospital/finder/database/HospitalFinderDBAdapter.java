package com.micro.health.hospital.finder.database;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.location.Location;
import android.util.Log;

import com.micro.health.hospital.finder.dto.TermDTO;

public class HospitalFinderDBAdapter {

	private static final String TAG = "HospitalFinderDBAdapter";
	public static DatabaseHelper mDbHelper;
	public SQLiteDatabase mDb;
	// make sure this matches the
	// package com.MyPackage;
	// at the top of this file
	private static String DB_PATH = "/data/data/com.MyPackage/databases/";

	// make sure this matches your database name in your assets folder
	// my database file does not have an extension on it
	// if yours does
	// add the extention
	private static final String DATABASE_NAME = "dbhospital_find.mp3";

	// Im using an sqlite3 database, I have no clue if this makes a difference
	// or not
	private static final int DATABASE_VERSION = 1;

	private final Context adapterContext;

	public HospitalFinderDBAdapter(Context context) {
		DB_PATH = "/data/data/" + context.getPackageName() + "/databases/";
		this.adapterContext = context;

	}

	public void open() throws SQLException {
		mDbHelper = new DatabaseHelper(adapterContext);

		try {
			mDbHelper.createDataBase();
		} catch (IOException ioe) {
			throw new Error("Unable to create database");
		}

		try {
			mDbHelper.openDataBase();
		} catch (SQLException sqle) {
			throw sqle;
		}
	}

	public void close() {
		mDbHelper.close();
	}

	/*public ArrayList<TermDTO> getLocationsForMap(Location location, double distance) {
		ArrayList<TermDTO> ret = new ArrayList<TermDTO>();
		if(location != null){
			String query = "select _id," +
					" latitude," +
					" longitude, " +
					"hospital_name, " +
					"address," +
					"percent_of_patients_who_reported_yes_they_would_definitely_recommend_the_hospital_," +
					"percent_of_patients_who_reported_no_they_would_not_recommend_the_hospital_, " +
					"city, " +
					"zip_code from hospital ";
			String whereclausecity = "";
			String whereclausezipcode = "";
			String whereclause = "";
			if(!HospitalApplication.prefs.getCity().equals("")) {
				whereclausecity = " city like '" + HospitalApplication.prefs.getCity() + "'";
			}
			if(HospitalApplication.prefs.getZipCode() != 0) {
				whereclausezipcode = " zip_code = '" + HospitalApplication.prefs.getZipCode() + "'";
			}
			if(!whereclausecity.equals("") && !whereclausezipcode.equals("")){
				whereclause = " where " + whereclausecity + " or " + whereclausezipcode;
			} else if(whereclausecity.equals("") && !whereclausezipcode.equals("")) {
				whereclause = " where " + whereclausezipcode;
			} else if(!whereclausecity.equals("") && whereclausezipcode.equals("")) {
				whereclause = " where " + whereclausecity;
			}
			String query1 = query + whereclause;
			Cursor mCursor = mDb.rawQuery(query1, null);
			if (mCursor != null) {
				for (mCursor.isBeforeFirst(); mCursor.moveToNext(); mCursor.isAfterLast()) {
					double endLatitude = mCursor.getDouble(1);
					double endLongitude = mCursor.getDouble(2);
					float[] results = new float[1];
					try {
						Location.distanceBetween(location.getLatitude(), location.getLongitude(), endLatitude, endLongitude, results);
						if (results != null && results.length > 0) {
							if (results[0] < distance) {
								TermDTO tempFav = new TermDTO();
								tempFav.setId(mCursor.getInt(0));
								tempFav.setHopital_name(mCursor.getString(3));
								tempFav.setAddress(mCursor.getString(4));
								tempFav.setPercent_of_patients_who_reported_yes_they_would_definitely_recommend_the_hospital_(mCursor.getInt(5));
								tempFav.setPercent_of_patients_who_reported_no_they_would_not_recommend_the_hospital_(mCursor.getInt(6));
								tempFav.setDistance(results[0]);
								tempFav.setLatitude(endLatitude);
								tempFav.setLongitude(endLongitude);
								tempFav.setCity(mCursor.getString(7));
								tempFav.setZip_code(mCursor.getInt(8));
								ret.add(tempFav);
							}
						}
					} catch (Exception e) {
						Log.v(TAG, e.toString());
						e.printStackTrace();
					}
				}
				mCursor.close();
			}
			
			String wherenotclausecity = "";
			String wherenotclausezipcode = "";
			String wherenotclause = "";
			if(!HospitalApplication.prefs.getCity().equals("")) {
				wherenotclausecity = " city not like '" + HospitalApplication.prefs.getCity() + "'";
			}
			if(HospitalApplication.prefs.getZipCode() != 0) {
				wherenotclausezipcode = " zip_code != '" + HospitalApplication.prefs.getZipCode() + "'";
			}
			
			if(!wherenotclausecity.equals("") && !wherenotclausezipcode.equals("")){
				wherenotclause = " where " + wherenotclausecity + " and " + wherenotclausezipcode;
			} else if(wherenotclausecity.equals("") && !wherenotclausezipcode.equals("")) {
				wherenotclause = " where " + wherenotclausezipcode;
			} else if(!wherenotclausecity.equals("") && wherenotclausezipcode.equals("")) {
				wherenotclause = " where " + wherenotclausecity;
			}
			
			String query2 = query + wherenotclause;
			mCursor = mDb.rawQuery(query2, null);
			if (mCursor != null) {
				for (mCursor.isBeforeFirst(); mCursor.moveToNext(); mCursor.isAfterLast()) {
					double endLatitude = mCursor.getDouble(1);
					double endLongitude = mCursor.getDouble(2);
					float[] results = new float[1];
					try {
						Location.distanceBetween(location.getLatitude(), location.getLongitude(), endLatitude, endLongitude, results);
						if (results != null && results.length > 0) {
							if (results[0] < distance) {
								TermDTO tempFav = new TermDTO();
								tempFav.setId(mCursor.getInt(0));
								tempFav.setHopital_name(mCursor.getString(3));
								tempFav.setAddress(mCursor.getString(4));
								tempFav.setPercent_of_patients_who_reported_yes_they_would_definitely_recommend_the_hospital_(mCursor.getInt(5));
								tempFav.setPercent_of_patients_who_reported_no_they_would_not_recommend_the_hospital_(mCursor.getInt(6));
								tempFav.setDistance(results[0]);
								tempFav.setLatitude(endLatitude);
								tempFav.setLongitude(endLongitude);
								tempFav.setCity(mCursor.getString(7));
								tempFav.setZip_code(mCursor.getInt(8));
								ret.add(tempFav);
							}
						}
					} catch (Exception e) {
						Log.v(TAG, e.toString());
						e.printStackTrace();
					}
				}
				mCursor.close();
			}
	
		}
		return ret;
	}*/
	
	public ArrayList<TermDTO> getLocationsForMap(Location location, double distance) {
		ArrayList<TermDTO> ret = new ArrayList<TermDTO>();
		if(location != null){
			String query = "select _id," +
					" latitude," +
					" longitude, " +
					"hospital_name, " +
					"address," +
					"percent_of_patients_who_reported_yes_they_would_definitely_recommend_the_hospital_," +
					"percent_of_patients_who_reported_no_they_would_not_recommend_the_hospital_ from hospital ";
			Cursor mCursor = mDb.rawQuery(query, null);
			if (mCursor != null) {
				for (mCursor.isBeforeFirst(); mCursor.moveToNext(); mCursor.isAfterLast()) {
					double endLatitude = mCursor.getDouble(1);
					double endLongitude = mCursor.getDouble(2);
					float[] results = new float[1];
					try {
						Location.distanceBetween(location.getLatitude(), location.getLongitude(), endLatitude, endLongitude, results);
						if (results != null && results.length > 0) {
							if (results[0] < distance) {
								TermDTO tempFav = new TermDTO();
								tempFav.setId(mCursor.getInt(0));
								tempFav.setHopital_name(mCursor.getString(3));
								tempFav.setAddress(mCursor.getString(4));
								tempFav.setPercent_of_patients_who_reported_yes_they_would_definitely_recommend_the_hospital_(mCursor.getInt(5));
								tempFav.setPercent_of_patients_who_reported_no_they_would_not_recommend_the_hospital_(mCursor.getInt(6));
								tempFav.setDistance(results[0]);
								tempFav.setLatitude(endLatitude);
								tempFav.setLongitude(endLongitude);
								ret.add(tempFav);
							}
						}
					} catch (Exception e) {
						Log.v(TAG, e.toString());
						e.printStackTrace();
					}
				}
				mCursor.close();
			}
			
		}
		return ret;
	}
	
	public ArrayList<TermDTO> getLocationsFromSearchString(Location location, double distance, String searchTxt) {
		ArrayList<TermDTO> ret = new ArrayList<TermDTO>();
			String query = "select _id, latitude, longitude, hospital_name, address, percent_of_patients_who_reported_yes_they_would_definitely_recommend_the_hospital_," +
					"percent_of_patients_who_reported_no_they_would_not_recommend_the_hospital_, city, zip_code from hospital where hospital_name like '%" + searchTxt + "%' OR zip_code like '%" + searchTxt + "%' OR city like '%" +searchTxt + "%'";
			Cursor mCursor = mDb.rawQuery(query, null);
			if (mCursor != null) {
				for (mCursor.isBeforeFirst(); mCursor.moveToNext(); mCursor.isAfterLast()) {
					double endLatitude = mCursor.getDouble(1);
					double endLongitude = mCursor.getDouble(2);
					float[] results = new float[1];
					try {
						if(location  != null) {
							Location.distanceBetween(location.getLatitude(), location.getLongitude(), endLatitude, endLongitude, results);	
						}
						TermDTO tempFav = new TermDTO();
						tempFav.setId(mCursor.getInt(0));
						tempFav.setHopital_name(mCursor.getString(3));
						tempFav.setAddress(mCursor.getString(4));
						tempFav.setPercent_of_patients_who_reported_yes_they_would_definitely_recommend_the_hospital_(mCursor.getInt(5));
						tempFav.setPercent_of_patients_who_reported_no_they_would_not_recommend_the_hospital_(mCursor.getInt(6));
						if (results != null && results.length > 0) {
							tempFav.setDistance(results[0]);
						}
						tempFav.setLatitude(endLatitude);
						tempFav.setLongitude(endLongitude);
						tempFav.setCity(mCursor.getString(7));
						tempFav.setZip_code(mCursor.getInt(8));
						ret.add(tempFav);
					} catch (Exception e) {
						Log.v(TAG, e.toString());
						e.printStackTrace();
					}
				}
				mCursor.close();
			}
		return ret;
	}
	
	public TermDTO getHospitalById(int id) {
		TermDTO tempFav = null;
		String query = "select " +
				"_id" +", " +
				"hospital_name"+ ", " +
				"address"+", " +
				"city"+", " +
				"state"+", " +
				"zip_code"+", " +
				"county_name"+", " +
				"phone_number"+", " +
				"percent_of_patients_who_reported_that_their_nurses_sometimes_or_never_communicated_well_"+", " +
				"percent_of_patients_who_reported_that_their_nurses_always_communicated_well_ "+", " +
				"percent_of_patients_who_reported_that_their_doctors_sometimes_or_never_communicated_well_"+", " +
				"percent_of_patients_who_reported_that_their_doctors_always_communicated_well_ "+", " +
				"percent_of_patients_who_reported_that_they_sometimes_or_never_received_help_as_soon_as_they_wanted_"+", " +
				"percent_of_patients_who_reported_that_they_always_received_help_as_soon_as_they_wanted_"+", " +
				"percent_of_patients_who_reported_that_their_pain_was_sometimes_or_never_well_controlled_"+", " +
				"percent_of_patients_who_reported_that_their_pain_was_always_well_controlled_"+", " +
				"percent_of_patients_who_reported_that_staff_sometimes_or_never_explained_about_medicines_before_giving_it_to_them_"+", " +
				"percent_of_patients_who_reported_that_staff_always_explained_about_medicines_before_giving_it_to_them_"+", " +
				"percent_of_patients_who_reported_that_their_room_and_bathroom_were_sometimes_or_never_clean_"+", " +
				"percent_of_patients_who_reported_that_their_room_and_bathroom_were_always_clean_"+", " +
				"percent_of_patients_who_reported_that_the_area_around_their_room_was_sometimes_or_never_quiet_at_night_"+", " +
				"percent_of_patients_who_reported_that_the_area_around_their_room_was_always_quiet_at_night_"+", " +
				"percent_of_patients_who_reported_that_yes_they_were_given_information_about_what_to_do_during_their_recovery_at_home_"+", " +
				"percent_of_patients_who_reported_that_they_were_not_given_information_about_what_to_do_during_their_recovery_at_home_"+", " +
				"percent_of_patients_who_gave_their_hospital_a_rating_of_6_or_lower_on_a_scale_from_0_lowest_to_10_highest_"+", " +
				"percent_of_patients_who_gave_their_hospital_a_rating_of_9_or_10_on_a_scale_from_0_lowest_to_10_highest_"+", " +
				"percent_of_patients_who_reported_no_they_would_not_recommend_the_hospital_"+", " +
				"percent_of_patients_who_reported_yes_they_would_definitely_recommend_the_hospital_"+", " +
				"number_of_completed_surveys"+", " +
				"survey_response_rate_percent"+", " +
				"latitude"+", " +
				"longitude" +", " + 
				"favorite" + ", " +
				"hospital_footnote" +
				" from hospital where _id = " + id; 
		Cursor mCursor = mDb.rawQuery(query, null);
		if (mCursor != null) {
			for (mCursor.isBeforeFirst(); mCursor.moveToNext(); mCursor.isAfterLast()) {
				tempFav = new TermDTO();
				tempFav.setId(mCursor.getInt(0));
				tempFav.setHopital_name(mCursor.getString(1));
				tempFav.setAddress(mCursor.getString(2));
				tempFav.setCity(mCursor.getString(3));
				tempFav.setState(mCursor.getString(4));
				tempFav.setZip_code(mCursor.getInt(5));
				tempFav.setCountry_name(mCursor.getString(6));
				tempFav.setPhone_number(mCursor.getString(7));
				tempFav.setPercent_of_patients_who_reported_that_their_nurses_sometimes_or_never_communicated_well_(mCursor.getInt(8));
				tempFav.setPercent_of_patients_who_reported_that_their_nurses_always_communicated_well_(mCursor.getInt(9));
				tempFav.setPercent_of_patients_who_reported_that_their_doctors_sometimes_or_never_communicated_well_(mCursor.getInt(10));
				tempFav.setPercent_of_patients_who_reported_that_their_doctors_always_communicated_well_(mCursor.getInt(11));
				tempFav.setPercent_of_patients_who_reported_that_they_sometimes_or_never_received_help_as_soon_as_they_wanted_(mCursor.getInt(12));
				tempFav.setPercent_of_patients_who_reported_that_they_always_received_help_as_soon_as_they_wanted_(mCursor.getInt(13));
				tempFav.setPercent_of_patients_who_reported_that_their_pain_was_sometimes_or_never_well_controlled_(mCursor.getInt(14));
				tempFav.setPercent_of_patients_who_reported_that_their_pain_was_always_well_controlled_(mCursor.getInt(15));
				tempFav.setPercent_of_patients_who_reported_that_staff_sometimes_or_never_explained_about_medicines_before_giving_it_to_them_(mCursor.getInt(16));
				tempFav.setPercent_of_patients_who_reported_that_staff_always_explained_about_medicines_before_giving_it_to_them_(mCursor.getInt(17));
				tempFav.setPercent_of_patients_who_reported_that_their_room_and_bathroom_were_sometimes_or_never_clean_(mCursor.getInt(18));
				tempFav.setPercent_of_patients_who_reported_that_their_room_and_bathroom_were_always_clean_(mCursor.getInt(19));
				tempFav.setPercent_of_patients_who_reported_that_the_area_around_their_room_was_sometimes_or_never_quiet_at_night_(mCursor.getInt(20));
				tempFav.setPercent_of_patients_who_reported_that_the_area_around_their_room_was_always_quiet_at_night_(mCursor.getInt(21));
				tempFav.setPercent_of_patients_who_reported_that_yes_they_were_given_information_about_what_to_do_during_their_recovery_at_home_(mCursor.getInt(22));
				tempFav.setPercent_of_patients_who_reported_that_they_were_not_given_information_about_what_to_do_during_their_recovery_at_home_(mCursor.getInt(23));
				tempFav.setPercent_of_patients_who_gave_their_hospital_a_rating_of_6_or_lower_on_a_scale_from_0_lowest_to_10_highest_(mCursor.getInt(24));
				tempFav.setPercent_of_patients_who_gave_their_hospital_a_rating_of_9_or_10_on_a_scale_from_0_lowest_to_10_highest_(mCursor.getInt(25));
				tempFav.setPercent_of_patients_who_reported_no_they_would_not_recommend_the_hospital_(mCursor.getInt(26));
				tempFav.setPercent_of_patients_who_reported_yes_they_would_definitely_recommend_the_hospital_(mCursor.getInt(27));
				tempFav.setNumber_of_completed_surveys(mCursor.getString(28));
				tempFav.setSurvey_response_rate_percent(mCursor.getInt(29));
				tempFav.setLatitude(mCursor.getDouble(30));
				tempFav.setLongitude(mCursor.getDouble(31));
				tempFav.setFavorites(mCursor.getInt(32)==1?true:false);
				tempFav.setHospitalNote(mCursor.getString(33));
			}
			mCursor.close();
		}
		return tempFav;
	}
	
	public ArrayList<TermDTO> getFavoritesList(Location location) {
		ArrayList<TermDTO> ret = new ArrayList<TermDTO>();
		if(location != null){
			String query = "select _id, latitude, longitude, hospital_name, address,percent_of_patients_who_reported_yes_they_would_definitely_recommend_the_hospital_,percent_of_patients_who_reported_no_they_would_not_recommend_the_hospital_, city, zip_code from hospital where favorite = 1";
			Cursor mCursor = mDb.rawQuery(query, null);
			if (mCursor != null) {
				for (mCursor.isBeforeFirst(); mCursor.moveToNext(); mCursor.isAfterLast()) {
					double endLatitude = mCursor.getDouble(1);
					double endLongitude = mCursor.getDouble(2);
					float[] results = new float[1];
					try {
						Location.distanceBetween(location.getLatitude(), location.getLongitude(), endLatitude, endLongitude, results);
						if (results != null && results.length > 0) {
								TermDTO tempFav = new TermDTO();
								tempFav.setId(mCursor.getInt(0));
								tempFav.setHopital_name(mCursor.getString(3));
								tempFav.setAddress(mCursor.getString(4));
								tempFav.setPercent_of_patients_who_reported_yes_they_would_definitely_recommend_the_hospital_(mCursor.getInt(5));
								tempFav.setPercent_of_patients_who_reported_no_they_would_not_recommend_the_hospital_(mCursor.getInt(6));
								tempFav.setDistance(results[0]);
								tempFav.setLatitude(endLatitude);
								tempFav.setLongitude(endLongitude);
								tempFav.setCity(mCursor.getString(7));
								tempFav.setZip_code(mCursor.getInt(8));
								ret.add(tempFav);
						}
					} catch (Exception e) {
						Log.v(TAG, e.toString());
						e.printStackTrace();
					}
				}
				mCursor.close();
			}
		}
		return ret;
	}
	
	public ArrayList<String> getAllHospitalNames() {
		ArrayList<String> ret = new ArrayList<String>();
		String query = "select hospital_name from hospital";
		Cursor mCursor = mDb.rawQuery(query, null);
		if (mCursor != null) {
			for (mCursor.isBeforeFirst(); mCursor.moveToNext(); mCursor.isAfterLast()) {
				ret.add(mCursor.getString(0));
			}
			mCursor.close();
		}
		return ret;
	}
	
	
	
	
	
	public void updateFavorite(int id, int fav) {
		ContentValues args = new ContentValues();
		args.put("favorite", fav);
		boolean s = mDb.update("hospital", args,
				"_id=" + id, null) > 0;
		if (!s) {
			Log.v(TAG, "Error while updating favorite:" + id);
		}
	}
	


	private class DatabaseHelper extends SQLiteOpenHelper {

		Context helperContext;

		private DatabaseHelper(Context context) {
			super(context, DATABASE_NAME, null, DATABASE_VERSION);
			DB_PATH = "/data/data/" + context.getPackageName() + "/databases/";
			helperContext = context;
		}

		@Override
		public void onCreate(SQLiteDatabase db) {
		}

		@Override
		public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
			Log.w(TAG, "Upgrading database!!!!!");
			// db.execSQL("");
			onCreate(db);
		}

		public void createDataBase() throws IOException {
			boolean dbExist = checkDataBase();
			if (dbExist) {
			} else {
				this.getReadableDatabase();
				try {
					this.close();
					copyDataBase();
				} catch (IOException e) {
					e.printStackTrace();
					throw new Error("Error copying database");
				}
			}
		}

		private boolean checkDataBase() {
			File f = new File(DB_PATH + DATABASE_NAME);
			return f.exists();
		}

		private void copyDataBase() throws IOException {

			// Open your local db as the input stream
			InputStream myInput = helperContext.getAssets().open(DATABASE_NAME);

			// Path to the just created empty db
			String outFileName = DB_PATH + DATABASE_NAME;

			// Open the empty db as the output stream
			OutputStream myOutput = new FileOutputStream(outFileName);

			// transfer bytes from the inputfile to the outputfile
			byte[] buffer = new byte[1024];
			int length;
			while ((length = myInput.read(buffer)) > 0) {
				myOutput.write(buffer, 0, length);
			}

			// Close the streams
			myOutput.flush();
			myOutput.close();
			myInput.close();
		}

		public void openDataBase() throws SQLException {
			// Open the database
			if(mDb!=null){
				if(mDb.isOpen()) {
					mDb.close(); }
			}
			String myPath = DB_PATH + DATABASE_NAME;
			mDb = SQLiteDatabase.openDatabase(myPath, null,
					SQLiteDatabase.OPEN_READWRITE);
		}

		@Override
		public synchronized void close() {

			if (mDb != null)
				mDb.close();

			super.close();

		}
	}

}
