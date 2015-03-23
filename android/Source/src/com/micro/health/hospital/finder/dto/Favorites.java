package com.micro.health.hospital.finder.dto;

public class Favorites implements Comparable<Favorites>{
	
	private int locationId;
	private double latitude;
	private double longitude;
	private float distance;
	
	public double getLatitude() {
		return latitude;
	}
	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}
	public double getLongitude() {
		return longitude;
	}
	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}
	public int getLocationId() {
		return locationId;
	}
	public void setLocationId(int locationId) {
		this.locationId = locationId;
	}
	public float getDistance() {
		return distance;
	}
	public void setDistance(float distance) {
		this.distance = distance;
	}
	
	
	
	@Override
	public String toString() {
		return "Favorites [locationId=" + locationId + ", latitude=" + latitude
				+ ", longitude=" + longitude + ", distance=" + distance + "]";
	}
	@Override
	public int compareTo(Favorites another) {
		if (!(another instanceof Favorites)) {
			throw new ClassCastException("Invalid object");
		} else {
			return Float.compare(this.distance, ((Favorites) another).getDistance());
		}
	}
}
