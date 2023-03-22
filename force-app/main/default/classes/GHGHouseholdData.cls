public class GHGHouseholdData {

        public class Parameters {
            public Integer energy;
            public String energy_unit;
        }

        public Emission_factor emission_factor;
        public Parameters parameters;

        public class Emission_factor {
            public String activity_id;
        }

	
        public static GHGHouseholdData parse(String json) {
            return (GHGHouseholdData) System.JSON.deserialize(json, GHGHouseholdData.class);
        }     
}