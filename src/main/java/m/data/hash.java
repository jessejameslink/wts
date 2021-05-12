package m.data;

import java.util.Collection;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Map;
import java.util.Set;

import m.common.tool.tool;

/**
 * java.util.Hashtable 소스를 사용하여 Exception 등이 발생하지 않도록 조치한 내용임.
 * @author  poemlife
 */
public class hash<V>{

	private Hashtable<String,V> data;
	
	public hash(Hashtable<String,V> data){
		this.data = data;
	}//end of hash();
	
	/**
     * Constructs a new, empty hashtable with the specified initial
     * capacity and the specified load factor.
     *
     * @param      initialCapacity   the initial capacity of the hashtable.
     * @param      loadFactor        the load factor of the hashtable.
     * @exception  IllegalArgumentException  if the initial capacity is less
     *             than zero, or if the load factor is nonpositive.
     */
    public hash(int initialCapacity, float loadFactor) {
    	this.data = new Hashtable<String,V>(initialCapacity, loadFactor);
    }//end of hash();

    /**
     * Constructs a new, empty hashtable with the specified initial capacity
     * and default load factor (0.75).
     *
     * @param     initialCapacity   the initial capacity of the hashtable.
     * @exception IllegalArgumentException if the initial capacity is less
     *              than zero.
     */
    public hash(int initialCapacity) {
    	this.data = new Hashtable<String,V>(initialCapacity);
    }//end of hash();

    /**
     * Constructs a new, empty hashtable with a default initial capacity (11)
     * and load factor (0.75).
     */
    public hash() {
    	this.data = new Hashtable<String,V>();
    }//end of hash();

    /**
     * Constructs a new hashtable with the same mappings as the given
     * Map.  The hashtable is created with an initial capacity sufficient to
     * hold the mappings in the given Map and a default load factor (0.75).
     *
     * @param t the map whose mappings are to be placed in this map.
     * @throws NullPointerException if the specified map is null.
     * @since   1.2
     */
    public hash(Map<String, ? extends V> t) {
    	this.data = new Hashtable<String,V>(t);
    }//end of hash();

    /**
     * Returns the number of keys in this hashtable.
     *
     * @return  the number of keys in this hashtable.
     */
    public synchronized int size() {
    	return this.data.size();
    }//end of size();

    /**
     * Tests if this hashtable maps no keys to values.
     *
     * @return  <code>true</code> if this hashtable maps no keys to values;
     *          <code>false</code> otherwise.
     */
    public synchronized boolean isEmpty() {
    	return this.data.isEmpty();
    }//end of isEmpty();

    /**
     * Returns an enumeration of the keys in this hashtable.
     *
     * @return  an enumeration of the keys in this hashtable.
     * @see     Enumeration
     * @see     #elements()
     * @see	#keySet()
     * @see	Map
     */
    public synchronized Enumeration<String> keys() {
    	return this.data.keys();
    }//end of keys();

    /**
     * Returns an enumeration of the values in this hashtable.
     * Use the Enumeration methods on the returned object to fetch the elements
     * sequentially.
     *
     * @return  an enumeration of the values in this hashtable.
     * @see     java.util.Enumeration
     * @see     #keys()
     * @see	#values()
     * @see	Map
     */
    public synchronized Enumeration<V> elements() {
    	return this.data.elements();
    }//end fo Enumeration();

    /**
     * Tests if some key maps into the specified value in this hashtable.
     * This operation is more expensive than the {@link #containsKey
     * containsKey} method.
     *
     * <p>Note that this method is identical in functionality to
     * {@link #containsValue containsValue}, (which is part of the
     * {@link Map} interface in the collections framework).
     *
     * @param      value   a value to search for
     * @return     <code>true</code> if and only if some key maps to the
     *             <code>value</code> argument in this hashtable as
     *             determined by the <tt>equals</tt> method;
     *             <code>false</code> otherwise.
     * @exception  NullPointerException  if the value is <code>null</code>
     */
    public synchronized boolean contains(V value) {
    	return this.data.contains(value);
    }//end of contains();

    /**
     * Returns true if this hashtable maps one or more keys to this value.
     *
     * <p>Note that this method is identical in functionality to {@link
     * #contains contains} (which predates the {@link Map} interface).
     *
     * @param value value whose presence in this hashtable is to be tested
     * @return <tt>true</tt> if this map maps one or more keys to the
     *         specified value
     * @throws NullPointerException  if the value is <code>null</code>
     * @since 1.2
     */
    public boolean containsValue(V value) {
    	return this.data.containsValue(value);
    }//end of containsValue();

    /**
     * Tests if the specified object is a key in this hashtable.
     *
     * @param   key   possible key
     * @return  <code>true</code> if and only if the specified object
     *          is a key in this hashtable, as determined by the
     *          <tt>equals</tt> method; <code>false</code> otherwise.
     * @throws  NullPointerException  if the key is <code>null</code>
     * @see     #contains(Object)
     */
    public synchronized boolean containsKey(String key) {
    	return this.data.containsKey(key);
    }//end of containsKey();

    /**
     * Returns the value to which the specified key is mapped,
     * or {@code null} if this map contains no mapping for the key.
     *
     * <p>More formally, if this map contains a mapping from a key
     * {@code k} to a value {@code v} such that {@code (key.equals(k))},
     * then this method returns {@code v}; otherwise it returns
     * {@code null}.  (There can be at most one such mapping.)
     *
     * @param key the key whose associated value is to be returned
     * @return the value to which the specified key is mapped, or
     *         {@code null} if this map contains no mapping for the key
     * @throws NullPointerException if the specified key is null
     * @see     #put(Object, Object)
     */
    public synchronized V get(String key, V defaultValue) {
    	V value = this.data.get(key);
    	if(value==null)		return defaultValue;
    	else				return value;
    }//end of get();

    /**
     * Returns the value to which the specified key is mapped,
     * or {@code null} if this map contains no mapping for the key.
     *
     * <p>More formally, if this map contains a mapping from a key
     * {@code k} to a value {@code v} such that {@code (key.equals(k))},
     * then this method returns {@code v}; otherwise it returns
     * {@code null}.  (There can be at most one such mapping.)
     *
     * @param key the key whose associated value is to be returned
     * @return the value to which the specified key is mapped, or
     *         {@code null} if this map contains no mapping for the key
     * @throws NullPointerException if the specified key is null
     * @see     #put(Object, Object)
     */
    public synchronized V get(String key) {
    	return this.data.get(key);
    }//end of get();

    /**
     * 주어진 key에 해당하는 value를 String type으로 return한다.
     * @param key
     * @param defaultValue
     * @return
     */
    public synchronized String getString(String key, String defaultValue){
    	V value = this.data.get(key);
    	if(value==null)		return defaultValue;
    	else				return value.toString();
    }//end of getString();
    
    /**
     * 주어진 key에 해당하는 value를 String type으로 return한다.
     * @param key
     * @return
     */
    public synchronized String getString(String key){
    	return this.getString(key, new String());
    }//end of getString();

    /**
     * key에 해당하는 value를 int type으로 return한다.
     * @param key
     * @param defaultValue
     * @return
     */
    public synchronized int getInt(String key, int defaultValue){
    	try{
    		return Integer.parseInt(this.getString(key, String.valueOf(defaultValue)).trim());
    	}catch(Exception e){
    		return defaultValue;
    	}
    }//end of getInt();
    
    /**
     * key에 해당하는 value를 int type으로 return한다.
     * @param key
     * @return
     */
    public synchronized int getInt(String key){
    	return this.getInt(key, 0);
    }//end of getInt();

    /**
     * key에 해당하는 value를 long type으로 return한다.
     * @param key
     * @param defaultValue
     * @return
     */
    public synchronized long getLong(String key, long defaultValue){
    	try{
    		return Long.parseLong(this.getString(key, String.valueOf(defaultValue)).trim());
    	}catch(Exception e){
    		return defaultValue;
    	}
    }//end of getInt();
    
    /**
     * key에 해당하는 value를 long type으로 return한다.
     * @param key
     * @return
     */
    public synchronized long getLong(String key){
    	return this.getLong(key, 0l);
    }//end of getLong();
    
    /**
     * key에 해당하는 value를 double type으로 return한다.
     * @param key
     * @param defaultValue
     * @return
     */
    public synchronized double getDouble(String key, double defaultValue){
    	try{
    		return Double.parseDouble(this.getString(key, String.valueOf(defaultValue)).trim());
    	}catch(Exception e){
    		return defaultValue;
    	}
    }//end of getDouble();
    
    /**
     * key에 해당하는 value를 int type으로 return한다.
     * @param key
     * @return
     */
    public synchronized double getDouble(String key){
    	return this.getDouble(key, 0d);
    }//end of getDouble();

    /**
     * key에 해당하는 value를 int type으로 return한다.
     * @param key
     * @param defaultValue
     * @return
     */
    public synchronized float getFloat(String key, float defaultValue){
    	try{
    		return Float.parseFloat(this.getString(key, String.valueOf(defaultValue)).trim());
    	}catch(Exception e){
    		return defaultValue;
    	}
    }//end of getFloat();
    
    /**
     * key에 해당하는 value를 int type으로 return한다.
     * @param key
     * @return
     */
    public synchronized float getFloat(String key){
    	return this.getFloat(key, 0f);
    }//end of getFloat();
    
    /**
     * Maps the specified <code>key</code> to the specified
     * <code>value</code> in this hashtable. Neither the key nor the
     * value can be <code>null</code>. <p>
     *
     * The value can be retrieved by calling the <code>get</code> method
     * with a key that is equal to the original key.
     *
     * @param      key     the hashtable key
     * @param      value   the value
     * @return     the previous value of the specified key in this hashtable,
     *             or <code>null</code> if it did not have one
     * @exception  NullPointerException  if the key or value is
     *               <code>null</code>
     * @see     Object#equals(Object)
     * @see     #get(Object)
     */
    public synchronized V put(String key, V value) {
    	if(tool.isNull(key))		return value;
    	if(value==null)				return this.remove(key.trim());
    	else						return this.data.put(key.trim(), value);
    }//end of put();

    /**
     * Removes the key (and its corresponding value) from this
     * hashtable. This method does nothing if the key is not in the hashtable.
     *
     * @param   key   the key that needs to be removed
     * @return  the value to which the key had been mapped in this hashtable,
     *          or <code>null</code> if the key did not have a mapping
     * @throws  NullPointerException  if the key is <code>null</code>
     */
    public synchronized V remove(String key) {
    	if(tool.isNull(key))		return null;
    	else						return this.data.remove(key.trim());
    }//end of remove();

    /**
     * Copies all of the mappings from the specified map to this hashtable.
     * These mappings will replace any mappings that this hashtable had for any
     * of the keys currently in the specified map.
     *
     * @param t mappings to be stored in this map
     * @throws NullPointerException if the specified map is null
     * @since 1.2
     */
    public synchronized void putAll(Map<String, ? extends V> t) {
    	this.data.putAll(t);
    }//end of putAll();

    /**
     * Clears this hashtable so that it contains no keys.
     */
    public synchronized void clear() {
    	this.data.clear();
    }//end of clear();

    /**
     * Creates a shallow copy of this hashtable. All the structure of the
     * hashtable itself is copied, but the keys and values are not cloned.
     * This is a relatively expensive operation.
     *
     * @return  a clone of the hashtable
     */
    public synchronized Object clone() {
    	return this.data.clone();
    }//end of clone();

    /**
     * Returns a string representation of this <tt>Hashtable</tt> object
     * in the form of a set of entries, enclosed in braces and separated
     * by the ASCII characters "<tt>,&nbsp;</tt>" (comma and space). Each
     * entry is rendered as the key, an equals sign <tt>=</tt>, and the
     * associated element, where the <tt>toString</tt> method is used to
     * convert the key and element to strings.
     *
     * @return  a string representation of this hashtable
     */
    public synchronized String toString() {
    	return this.data.toString();
    }//end of toString();

    /**
     * Returns a {@link Set} view of the keys contained in this map.
     * The set is backed by the map, so changes to the map are
     * reflected in the set, and vice-versa.  If the map is modified
     * while an iteration over the set is in progress (except through
     * the iterator's own <tt>remove</tt> operation), the results of
     * the iteration are undefined.  The set supports element removal,
     * which removes the corresponding mapping from the map, via the
     * <tt>Iterator.remove</tt>, <tt>Set.remove</tt>,
     * <tt>removeAll</tt>, <tt>retainAll</tt>, and <tt>clear</tt>
     * operations.  It does not support the <tt>add</tt> or <tt>addAll</tt>
     * operations.
     *
     * @since 1.2
     */
    public Set<String> keySet() {
    	return this.data.keySet();
    }//end of keySet();

    /**
     * Returns a {@link Set} view of the mappings contained in this map.
     * The set is backed by the map, so changes to the map are
     * reflected in the set, and vice-versa.  If the map is modified
     * while an iteration over the set is in progress (except through
     * the iterator's own <tt>remove</tt> operation, or through the
     * <tt>setValue</tt> operation on a map entry returned by the
     * iterator) the results of the iteration are undefined.  The set
     * supports element removal, which removes the corresponding
     * mapping from the map, via the <tt>Iterator.remove</tt>,
     * <tt>Set.remove</tt>, <tt>removeAll</tt>, <tt>retainAll</tt> and
     * <tt>clear</tt> operations.  It does not support the
     * <tt>add</tt> or <tt>addAll</tt> operations.
     *
     * @since 1.2
     */
    public Set<Map.Entry<String,V>> entrySet() {
    	return this.data.entrySet();
    }//end of entrySet();

    /**
     * Returns a {@link Collection} view of the values contained in this map.
     * The collection is backed by the map, so changes to the map are
     * reflected in the collection, and vice-versa.  If the map is
     * modified while an iteration over the collection is in progress
     * (except through the iterator's own <tt>remove</tt> operation),
     * the results of the iteration are undefined.  The collection
     * supports element removal, which removes the corresponding
     * mapping from the map, via the <tt>Iterator.remove</tt>,
     * <tt>Collection.remove</tt>, <tt>removeAll</tt>,
     * <tt>retainAll</tt> and <tt>clear</tt> operations.  It does not
     * support the <tt>add</tt> or <tt>addAll</tt> operations.
     *
     * @since 1.2
     */
    public Collection<V> values() {
    	return this.data.values();
    }//end of values();

    /**
     * Compares the specified Object with this Map for equality,
     * as per the definition in the Map interface.
     *
     * @param  o object to be compared for equality with this hashtable
     * @return true if the specified Object is equal to this Map
     * @see Map#equals(Object)
     * @since 1.2
     */
    public synchronized boolean equals(hash<V> o) {
    	return this.equals(o);
    }//end of equals();

    /**
     * Returns the hash code value for this Map as per the definition in the
     * Map interface.
     *
     * @see Map#hashCode()
     * @since 1.2
     */
    public synchronized int hashCode() {
    	return this.data.hashCode();
    }//end of hashCode();

}//end of hash();
