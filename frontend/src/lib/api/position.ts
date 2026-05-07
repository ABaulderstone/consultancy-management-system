import type { NormalizedPositionResponse, PositionResponse } from '../types/position';
import { httpClient } from './client';

function normalizePosition(position: PositionResponse): NormalizedPositionResponse {
	return {
		...position,
		minSalary: Number(position.minSalary),
		maxSalary: Number(position.maxSalary)
	};
}

export const positionsApi = {
	list: async () => {
		const positions = await httpClient.get<PositionResponse[]>('/positions');
		return positions.map(normalizePosition);
	}
};
