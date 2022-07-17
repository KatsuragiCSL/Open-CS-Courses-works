import java.util.HashMap;
import java.util.Map;

/**
 * This class provides all code necessary to take a query box and produce
 * a query result. The getMapRaster method must return a Map containing all
 * seven of the required fields, otherwise the front end code will probably
 * not draw the output correctly.
 */
public class Rasterer {

    private static final double ROOT_ULLAT = MapServer.ROOT_ULLAT, ROOT_ULLON = MapServer.ROOT_ULLON, ROOT_LRLAT = MapServer.ROOT_LRLAT, ROOT_LRLON = MapServer.ROOT_LRLON;
    private static final int TILE_SIZE = MapServer.TILE_SIZE;
    public Rasterer() {
        // YOUR CODE HERE
    }

    /**
     * Takes a user query and finds the grid of images that best matches the query. These
     * images will be combined into one big image (rastered) by the front end. <br>
     *
     *     The grid of images must obey the following properties, where image in the
     *     grid is referred to as a "tile".
     *     <ul>
     *         <li>The tiles collected must cover the most longitudinal distance per pixel
     *         (LonDPP) possible, while still covering less than or equal to the amount of
     *         longitudinal distance per pixel in the query box for the user viewport size. </li>
     *         <li>Contains all tiles that intersect the query bounding box that fulfill the
     *         above condition.</li>
     *         <li>The tiles must be arranged in-order to reconstruct the full image.</li>
     *     </ul>
     *
     * @param params Map of the HTTP GET request's query parameters - the query box and
     *               the user viewport width and height.
     *
     * @return A map of results for the front end as specified: <br>
     * "render_grid"   : String[][], the files to display. <br>
     * "raster_ul_lon" : Number, the bounding upper left longitude of the rastered image. <br>
     * "raster_ul_lat" : Number, the bounding upper left latitude of the rastered image. <br>
     * "raster_lr_lon" : Number, the bounding lower right longitude of the rastered image. <br>
     * "raster_lr_lat" : Number, the bounding lower right latitude of the rastered image. <br>
     * "depth"         : Number, the depth of the nodes of the rastered image <br>
     * "query_success" : Boolean, whether the query was able to successfully complete; don't
     *                    forget to set this to true on success! <br>
     */
    public Map<String, Object> getMapRaster(Map<String, Double> params) {

        // System.out.println(params);
        Map<String, Object> results = new HashMap<>();
        /* System.out.println("Since you haven't implemented getMapRaster, nothing is displayed in "
                           + "your browser."); */
        double ullat = params.get("ullat");
        double ullon = params.get("ullon");
        double lrlat = params.get("lrlat");
        double lrlon = params.get("lrlon");
        double width = params.get("w");
        double height = params.get("h");
        int depth = computeDepth(lrlon - ullon, width);
        boolean query_success = true;

        //boundary checks
        if (ullat < lrlat || lrlon < ullon || ROOT_LRLON <= ullon || lrlon <= ROOT_ULLON || ullat <= ROOT_LRLAT || ROOT_ULLAT <= lrlat ) {
            query_success = false;
        }

        double widthPerPicture = (ROOT_LRLON - ROOT_ULLON) / Math.pow(2.0, depth);
        double heightPerPicture = (ROOT_ULLAT - ROOT_LRLAT) / Math.pow(2.0, depth);
        // # of pic at the boundary
        int xMin = (int) Math.floor((ullon - ROOT_ULLON) / widthPerPicture);
        int xMax = (int) Math.floor((lrlon - ROOT_ULLON) / widthPerPicture);
        int yMin = (int) Math.floor((ROOT_ULLAT - ullat) / heightPerPicture);
        int yMax = (int) Math.floor((ROOT_ULLAT - lrlat) / heightPerPicture);
        // boundary of the pic
        double xMinBound = ROOT_ULLON + xMin * widthPerPicture;
        double xMaxBound = ROOT_ULLON + (xMax + 1) * widthPerPicture;
        double yMinBound = ROOT_ULLAT - yMin * heightPerPicture;
        double yMaxBound = ROOT_ULLAT - (yMax + 1) * heightPerPicture;

        // edge cases
        if (ullon < ROOT_ULLON) {
            xMinBound = ROOT_ULLON;
            xMin = 0;
        }
        if (lrlon > ROOT_LRLON) {
            xMax = (int)Math.pow(2, depth) - 1;
            xMaxBound = ROOT_LRLON;
        }
        if (ullat > ROOT_ULLAT) {
            yMin = 0;
            yMinBound = ROOT_ULLAT;
        }
        if (lrlat < ROOT_LRLAT) {
            yMax = (int)Math.pow(2, depth) - 1;
            yMaxBound = ROOT_LRLAT;
        }

        // grids matrix
        String[][] render_grid = new String[yMax - yMin + 1][xMax - xMin + 1];
        for (int i = yMin; i <= yMax; i++) {
            for (int j = xMin; j <= xMax; j++) {
                render_grid[i - yMin][j - xMin] = "d" + depth + "_x" + j + "_y" + i + ".png";
            }
        }

        results.put("render_grid", render_grid);
        results.put("raster_ul_lon", xMinBound);
        results.put("raster_lr_lon", xMaxBound);
        results.put("raster_ul_lat", yMinBound);
        results.put("raster_lr_lat", yMaxBound);
        results.put("depth", depth);
        results.put("query_success", query_success);

        return results;
    }

    /**
     * Takes the difference in longitude and the width of the query area and return the depth.
     *
     * @param lonDiff difference of longitudes.
     * @param w width of the query area.
     *
     * @return An int that indicates the depth of the images.
     */
    private int computeDepth(double lonDiff, double w) {
        double lonDPP = lonDiff / w;
        double n = Math.log((ROOT_LRLON - ROOT_ULLON) / (lonDPP * TILE_SIZE)) / Math.log(2.0);
        int ret = (int)Math.ceil(n);
        return ret >= 7 ? 7 : ret;
    }

}
