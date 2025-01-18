package fr.n7.sat;

import java.io.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.logging.*;
import com.microsoft.z3.*;

class OutOfBoundsException extends Exception {
    public OutOfBoundsException(String message) {
        super(message);
    }
}

class Sudoku {
    private static final Logger LOGGER =
        Logger.getLogger(fr.n7.sat.Sudoku.class.getName());
    private static final ConsoleHandler CONSOLE_HANDLER = new ConsoleHandler();

    static {
        System.setProperty("java.util.logging.SimpleFormatter.format",
                           "[%4$-4s] %5$s %n");

        CONSOLE_HANDLER.setFormatter(new SimpleFormatter());
        LOGGER.setUseParentHandlers(false);
        LOGGER.addHandler(CONSOLE_HANDLER);
    }

    private int                 nInit;
    private Context             context;
    private Solver              solver;
    private BoolExpr            grid[][][];
    private ArrayList<BoolExpr> initValues;
    private boolean             logEnabled;

    private static String clauseToString(Collection<BoolExpr> c) {
        StringBuilder sb = new StringBuilder("[ ");

        for (BoolExpr e: c) {
            sb.append(e.toString());
            sb.append(" ");
        }

        sb.append("]");

        return sb.toString();
    }

    private void addExistenceConstraints() {
        if (this.logEnabled) {
            LOGGER.fine("adding existence constraints");
            LOGGER.fine("----------------------------");
        }

        for (int i = 0; i < this.grid.length; i++) {
            for (int j = 0; j < this.grid.length ; j++) {
                this.solver.add(this.context.mkOr(this.grid[i][j]));

                if (this.logEnabled) {
                    LOGGER.fine("adding clause " + clauseToString(Arrays.asList(this.grid[i][j])));
                }
            }
        }
    }

    private void addColumnConstraints() {
        if (this.logEnabled) {
            LOGGER.fine("adding column constraints");
            LOGGER.fine("-------------------------");
        }

        for (int j = 0; j < this.grid.length; j++) {
            for (int v = 0; v < this.grid.length; v++) {
                // each value v should happen in each column j
                BoolExpr columnConstraints[] = new BoolExpr[this.grid.length];

                for (int i = 0; i < this.grid.length ; i++) {
                    columnConstraints[i] = this.grid[i][j][v];
                }

                this.solver.add(this.context.mkOr(columnConstraints));

                if (this.logEnabled) {
                    LOGGER.fine("adding clause " +
                                clauseToString(Arrays.asList(columnConstraints)));
                }

                // each value v appears at most one time in each
                // column
                for (int i1 = 0; i1 < this.grid.length; i1++) {
                    for (int i2 = 0; i2 < this.grid.length; i2++) {
                        if (i1 != i2) {
                            this.solver.add(this.context.mkImplies(
                                                this.grid[i1][j][v],
                                                this.context.mkNot(this.grid[i2][j][v])
                                                ));

                            if (this.logEnabled) {
                                LOGGER.fine("adding " + this.grid[i1][j][v].toString() +
                                                 " -> not " + this.grid[i2][j][v].toString());
                            }
                        }
                    }
                }
            }
        }
    }

    private void addRowConstraints() {
        if (this.logEnabled) {
            LOGGER.fine("adding row constraints");
            LOGGER.fine("----------------------");
        }

        for (int i = 0; i < this.grid.length; i++) {
            for (int v = 0; v < this.grid.length; v++) {
                // each value v should happen in each row i
                BoolExpr rowConstraints[] = new BoolExpr[this.grid.length];

                for (int j = 0; j < this.grid.length ; j++) {
                    rowConstraints[j] = this.grid[i][j][v];
                }

                this.solver.add(this.context.mkOr(rowConstraints));

                if (this.logEnabled) {
                    LOGGER.fine("adding clause " +
                                clauseToString(Arrays.asList(rowConstraints)));
                }

                // each value v appears at most one time in each
                // row
                for (int j1 = 0; j1 < this.grid.length; j1++) {
                    for (int j2 = 0; j2 < this.grid.length; j2++) {
                        if (j1 != j2) {
                            this.solver.add(this.context.mkImplies(
                                                this.grid[i][j1][v],
                                                this.context.mkNot(this.grid[i][j2][v])
                                                ));

                            if (this.logEnabled) {
                                LOGGER.fine("adding " + this.grid[i][j1][v].toString() +
                                                 " -> not " + this.grid[i][j2][v].toString());
                            }
                        }
                    }
                }
            }
        }
    }

    private void addSubGridsConstraints() {
        if (this.logEnabled) {
            LOGGER.fine("adding subgrids constraints");
            LOGGER.fine("---------------------------");
        }

        for (int isg = 0; isg < this.nInit; isg++) {
            for (int jsg = 0; jsg < this.nInit; jsg++) {
                // each value v should happen in each subgrid
                for (int v = 0; v < this.grid.length; v++) {
                    BoolExpr subGridConstraints[] = new BoolExpr[this.grid.length];

                    for (int x = 0; x < this.nInit; x++) {
                        for (int y = 0; y < this.nInit; y++) {
                            subGridConstraints[x * this.nInit + y] =
                                this.grid[isg * this.nInit + x][jsg * this.nInit + y][v];
                        }
                    }

                    if (this.logEnabled) {
                        LOGGER.fine("adding clause " +
                                    clauseToString(Arrays.asList(subGridConstraints)));
                    }

                    this.solver.add(this.context.mkOr(subGridConstraints));
                }
            }
        }
    }

    Sudoku(int n, boolean logEnabled) {
        this.logEnabled = logEnabled;

        if (this.logEnabled) {
            CONSOLE_HANDLER.setLevel(Level.FINE);
            LOGGER.setLevel(Level.FINE);
            LOGGER.info("*** FINE log enabled ***");
        } else {
            CONSOLE_HANDLER.setLevel(Level.INFO);
            LOGGER.setLevel(Level.INFO);
            LOGGER.info("*** INFO log enabled ***");
        }

        this.initValues = new ArrayList<>();

        HashMap<String, String> cfg = new HashMap<String, String>();
        cfg.put("model", "true");

        this.context = new Context(cfg);
        this.solver  = context.mkSolver();
        this.nInit   = n;

        int w = n * n;

        this.grid = new BoolExpr[w][w][w];

        for (int i = 0; i < w; i++) {
            for (int j = 0; j < w; j++) {
                for (int k = 0; k < w; k++) {
                    this.grid[i][j][k] =
                        this.context.mkBoolConst("" + i + "_" + j + "_" + (k + 1));
                }
            }
        }

        long startTime = System.currentTimeMillis();

        this.addExistenceConstraints();
        this.addColumnConstraints();
        this.addRowConstraints();
        this.addSubGridsConstraints();

        long stopTime    = System.currentTimeMillis();
        long elapsedTime = stopTime - startTime;

        LOGGER.info("time to build constraints: " + elapsedTime + "ms");
    }

    void print() {
        Model m = this.solver.getModel();

        if (m == null) {
            return;
        }

        for (int i = 0; i < this.grid.length; i++) {
            for (int j = 0; j < this.grid.length; j++) {
                boolean multipleValues = false;
                int     value          = -1;

                for (int k = 0; k < this.grid.length; k++) {
                    if (m.getConstInterp(this.grid[i][j][k]) != null &&
                        m.getConstInterp(this.grid[i][j][k]).isTrue()) {
                        if (value != -1) {
                            multipleValues = true;
                        } else {
                            value = k + 1;
                        }
                    }
                }

                if (value != -1) {
                    if (multipleValues) {
                        System.out.print("\033[7m" + value + "\033[0m ");
                    } else {
                        System.out.print("" + value + " ");
                    }
                } else {
                    System.out.print("_ ");
                }
            }

            System.out.println();
        }
    }

    Status solve() {
        long startTime = System.currentTimeMillis();

        Status s = this.solver.check();

        long stopTime    = System.currentTimeMillis();
        long elapsedTime = stopTime - startTime;

        LOGGER.info("time to solve problem: " + elapsedTime + "ms");

        return s;
    }

    void addValue(int i, int j, int v) throws OutOfBoundsException {
        if (i < 0 || j < 0 || v < 1 ||
            i >= this.grid.length || j >= this.grid.length || v > this.grid.length) {
            throw new OutOfBoundsException(String.format("problem when adding (%d, %d, %d)", i , j, v));
        }

        this.initValues.add(this.grid[i][j][v - 1]);
        this.solver.add(this.grid[i][j][v - 1]);
    }

    void addCurrentSolutionAsCube() {
        Model m = this.solver.getModel();

        ArrayList<BoolExpr> cube = new ArrayList<BoolExpr>();

        for (int i = 0; i < this.grid.length; i++) {
            for (int j = 0; j < this.grid.length; j++) {
                for (int k = 0; k < this.grid.length; k++) {
                    if (! this.initValues.contains(this.grid[i][j][k]) &&
                        m.getConstInterp(this.grid[i][j][k]) != null &&
                        m.getConstInterp(this.grid[i][j][k]).isTrue()) {
                        cube.add(this.grid[i][j][k]);
                    }
                }
            }
        }

        this.solver.add(this.context.mkNot(this.context.mkAnd(cube.toArray(new BoolExpr[0]))));
    }


    static Sudoku loadSudoku(String filename, boolean logEnabled) throws OutOfBoundsException, IOException {
        BufferedReader br = new BufferedReader(new FileReader(filename));

        // first line contains dimension
        String line   = br.readLine();
        int    n      = Integer.parseInt(line);
        Sudoku sudoku = new Sudoku(n, logEnabled);

        // parse each line
        int i = 0;

        while ((line = br.readLine()) != null) {
            String values[] = line.split(",");

            for (int j = 0; j < values.length; j++) {
                if (! values[j].equals("")) {
                    sudoku.addValue(i, j, Integer.parseInt(values[j]));
                }
            }

            i++;
        }

        br.close();

        return sudoku;
    }
}
