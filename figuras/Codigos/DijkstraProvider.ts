import Graph from "node-dijkstra";

import { HouseOfQuality } from "../../../../../modules/requirements/entities/HouseOfQuality";
import { ISingleShortestPathProvider } from "../ISingleShortestPathProvider";

interface IPathResult {
  path: string[];
  cost: number;
}

class DijkstraProvider implements ISingleShortestPathProvider {
  run(data: HouseOfQuality[]): number[] {
    const graph = new Graph();

    const nfunctionalIds = data.map((relation) => {
      const { nfunctional_id, functional_id, weight } = relation;
      graph.addNode(nfunctional_id.toString(), {
        [functional_id.toString()]: weight,
      });
      graph.addNode(functional_id.toString(), {
        [nfunctional_id.toString()]: weight,
      });

      return relation.nfunctional_id;
    });

    const uniqueNfunctionalIds = [...new Set(nfunctionalIds)];

    const paths = uniqueNfunctionalIds.flatMap((S, i) =>
      uniqueNfunctionalIds.slice(i + 1).map(
        (V) =>
          graph.path(S.toString(), V.toString(), {
            cost: true,
          }) as IPathResult
      )
    );

    const pathsCosts = paths.map((path) => path.cost);
    const greatestPathCostIndex = pathsCosts.indexOf(Math.max(...pathsCosts));

    const pathCasted = paths[greatestPathCostIndex].path.map((functional_id) =>
      parseInt(functional_id, 10)
    );

    return pathCasted;
  }
}

export { DijkstraProvider };
